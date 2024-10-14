class Issue < ApplicationRecord
  belongs_to :club
  has_many :issue_questions, dependent: :destroy
  has_many :answers, through: :issue_questions

  accepts_nested_attributes_for :issue_questions, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validate :no_updates_after_sent, on: :update

  before_validation :set_defaults
  before_save :clean_inputs
  before_destroy :remove_all_jobs_for_issue
  after_create :generate_questions, :generate_sections
  after_create :schedule_reminders, :schedule_delivery
  after_update :reschedule_reminders, :reschedule_delivery, if: :saved_change_to_deliver_at?

  scope :not_sent, -> { where("sent_at IS NULL") }
  scope :in_progress, -> { where("open_at < ? AND deliver_at > ? AND sent_at IS NULL", Time.current, Time.current) }
  scope :upcoming, -> { where("open_at > ?", Time.current) }
  scope :sent, -> { where("sent_at IS NOT NULL").order(sent_at: :desc) }
  scope :deliverable, -> { where("deliver_at <= ? AND sent_at IS NULL", Time.current) }

  def questions
    issue_questions.where(section: "questions")
  end

  def questions_grouped_by_section
    sort_order = Club.sections
    issue_questions.group_by(&:section).sort_by { |section, _| sort_order.index(section.to_sym) }
  end

  # Used to get a members answers or all answers for the issue, grouped by section
  # @param member [Member, nil] The member to get answers for, or nil for all answers
  # @return [[{:key=>"", <ClubSection>, :questions=>[{question: <IssueQuestion>, answers: [<Answer>]}]}] An array of hashes containing the section, questions, and answers for the issue
  def sections_questions_answers(member = nil, visible_members = nil)
    # For non-admins, exclude admin only sections when viewing own answers
    exclude = member && !member&.can_manage? ? Club.admin_only_sections.map(&:to_s) : []
    sections = self.sections - exclude
    answer = proc { |q|
      if member
        [ q.answers.find_or_initialize_by(member: member) ]
      else
        visible_members ? q.answers.where(member: visible_members) : q.answers
      end
    }
    sections.map do |section|
      {
        key: section,
        questions: issue_questions.in_section(section).map do |q|
          { question: q, answers: answer.call(q) }
        end
      }
    end.reject { |section| section[:questions].empty? }
  end

  def issue_answers
    answers.includes(:issue_question).group_by { |a| a.issue_question.section }
  end

  def generate_sections
    # Exclude the questions section because it is handled separately
    excluded_sections = [ :questions ]
    Club.sections.each do |key|
      next if excluded_sections.include?(key)
      option = Club.sections_options[key]
      issue_questions.create!(title: option[:title], prompt: option[:description], section: key.to_s, asked_by: "System", kind: option[:kind], options: option[:options])
    end
  end

  def generate_questions(count = club.default_number_questions)
    return unless sections.include?("questions")

    questions = Question.order("RANDOM()").limit(count)
    issue_questions.create!(questions.map { |q| q.attributes.slice("prompt", "category", "asked_by") })
  end

  def in_progress?
    open_at < Time.current && deliver_at > Time.current && sent_at.nil?
  end

  def upcoming?
    open_at > Time.current && sent_at.nil?
  end

  def sent?
    sent_at.present?
  end

  def unsent?
    sent_at.nil?
  end

  def waiting_for_reply?(member)
    in_progress? && !answered_by?(member)
  end

  def answered_by?(member)
    answers.where(member: member).any?
  end

  def section_enabled?(section)
    sections.include?(section.to_s)
  end

  def enabled_answers
    answers.where(issue_questions: { section: sections })
  end

  def enabled_answers_for_member(member)
    enabled_answers.where(member: member)
  end

  def time_until_delivery
    deliver_at - Time.current
  end

  def deliver(send_emails = true, notify_club = true)
    return if sent?
    remove_all_jobs_for_issue

    send_delivery_emails if send_emails
    update(sent_at: Time.current)
    club.notify_club_of_delivery(self) if notify_club
  end

  def send_delivery_emails
    club.members.active.each do |member|
      IssueMailer.deliver_issue(member, self).deliver_later
    end
  end

  def send_reminder_emails
    return unless in_progress?

    club.members.active.each do |member|
      unless answered_by?(member)
        IssueMailer.reply_reminder(member, self).deliver_later
      end
    end
  end

  def undeliver
    update(sent_at: nil)
  end

  private

  def set_defaults
    return if club.nil?
    self.sections ||= club.active_sections
    self.title ||= "Issue ##{club.issues.count + 1}"
    self.deliver_at ||= Time.current.in_time_zone(club.timezone).beginning_of_day + club.frequency_in_days.days + club.delivery_time_in_hours.hours
    self.open_at ||= self.deliver_at - 7.days
  end

  def clean_inputs
    self.sections = sections.reject(&:blank?)
    self.deliver_at = deliver_at.change(sec: 0)
    self.open_at = open_at.change(sec: 0)
  end

  def schedule_reminders
    intervals = [ 1.month, 1.week, 3.days, 1.day ]
    intervals.each do |interval|
      # This condition checks if it's appropriate to schedule a reminder:
      # 1. The reminder time (deliver_at - interval) should not be before the issue opens (>= open_at)
      # 2. The reminder time should be in the future (> Time.current)
      # 3. The reminder should be at least 1 day after the issue opens
      # If both conditions are met, we schedule a reminder for this interval
      if deliver_at - interval >= open_at && deliver_at - interval > Time.current && deliver_at - interval >= open_at + 1.day
        schedule_reminder(interval)
      end
    end
  end

  def schedule_delivery
    IssueDeliveryJob.set(wait_until: deliver_at.in_time_zone(club.timezone)).perform_later(id)
  end

  def schedule_reminder(interval)
    reminder_time = deliver_at.in_time_zone(club.timezone) - interval
    IssueReminderJob.set(wait_until: reminder_time).perform_later(id, interval)
  end

  def reschedule_reminders
    jobs_for_issue("IssueReminderJob").each(&:destroy)
    schedule_reminders
  end

  def reschedule_delivery
    jobs_for_issue("IssueDeliveryJob").each(&:destroy)
    schedule_delivery
  end

  def remove_all_jobs_for_issue
    jobs_for_issue.each(&:destroy!)
  end

  # TODO: do better
  def jobs_for_issue(class_name = nil, id = self.id)
    jobs = class_name ? SolidQueue::Job.where(class_name: class_name) : SolidQueue::Job.all
    jobs.select { |job| job.arguments["arguments"].include?(id) }
  end

  def no_updates_after_sent
    if sent_at_was.present? && (changes.keys - [ "sent_at" ]).any?
      errors.add(:base, "Cannot update issue after it has been sent, except to undeliver")
    end
  end
end
