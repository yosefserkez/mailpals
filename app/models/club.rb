class Club < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :issues, dependent: :destroy

  THEMES = %w[base cute retro].freeze

  validates :theme, inclusion: { in: THEMES }

  validates :title, presence: true
  validates :invite_code, presence: true, uniqueness: true
  validates :default_number_questions, presence: true, numericality: { greater_than: 0, less_than: 5 }
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  after_initialize :set_defaults, if: :new_record?
  after_initialize :generate_invite_code, if: :new_record?

  after_create :generate_issues
  after_update :update_live_issue, if: :saved_change_to_sections?
  after_update :handle_active_change, if: :saved_change_to_active?
  after_update :recalculate_issue_dates, if: -> { saved_change_to_delivery_frequency? || saved_change_to_delivery_time? || saved_change_to_delivery_day? || saved_change_to_timezone? }
  accepts_nested_attributes_for :members, allow_destroy: true, reject_if: :all_blank

  def self.delivery_frequencies
    { biweekly: 14, weekly: 7, monthly: 28, quarterly: 90, yearly: 365, daily: 1 }
  end

  def self.delivery_times
    { morning: 8, afternoon: 12, evening: 18 }
  end

  def self.delivery_days
    { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7 }
  end

  def self.sections
    sections_options.keys
  end

  def self.sections_options
    {
      questions: {
        title: I18n.t("clubs.sections.questions.title"),
        description: I18n.t("clubs.sections.questions.description"),
        kind: "text",
        options: nil
      },
      photo_wall: {
        title: I18n.t("clubs.sections.photo_wall.title"),
        description: I18n.t("clubs.sections.photo_wall.description"),
        kind: "image",
        options: nil
      },
      one_good_thing: {
        title: I18n.t("clubs.sections.one_good_thing.title"),
        description: I18n.t("clubs.sections.one_good_thing.description"),
        kind: "text",
        options: nil
      },
      shout_outs: {
        title: I18n.t("clubs.sections.shout_outs.title"),
        description: I18n.t("clubs.sections.shout_outs.description"),
        kind: "text",
        options: nil
      },
      phone_a_friend: {
        title: I18n.t("clubs.sections.phone_a_friend.title"),
        description: I18n.t("clubs.sections.phone_a_friend.description"),
        kind: "text",
        options: nil
      },
      check_it_out: {
        title: I18n.t("clubs.sections.check_it_out.title"),
        description: I18n.t("clubs.sections.check_it_out.description"),
        kind: "text",
        options: nil
      },
      announcements: {
        title: I18n.t("clubs.sections.announcements.title"),
        description: I18n.t("clubs.sections.announcements.description"),
        kind: "text",
        options: nil
      }
    }
  end

  def membership(user)
    members.find_by(user: user)
  end

  def is_member?(user)
    membership(user).present?
  end

  def is_owner?(user)
    membership(user)&.owner?
  end

  def owner_name
    owner.display_name
  end

  def owner
    members.find_by(role: :owner)
  end

  def can_manage?(user)
    member = membership(user)
    member.admin? || member.owner?
  end

  def active_sections
    sections.map(&:to_sym)
  end

  def inactive?
    !active
  end

  def current_issue
    issues.in_progress.first
  end

  def upcoming_issue
    issues.upcoming.first
  end

  def invite_code_url
    base_url = Rails.env.production? ? "https://mailpals.net" : "http://localhost:3000"
    "#{base_url}/join/#{invite_code}"
  end

  def self.admin_only_sections
    [ :announcements ]
  end

  def generate_issue(open_at, deliver_at)
    issues.create!(
      title: "Issue ##{issues.count + 1}",
      open_at: open_at,
      deliver_at: deliver_at,
      sections: active_sections
    )
  end

  def generate_issues
    return unless active

    current_issue = issues.not_sent.order(deliver_at: :asc).first
    next_issue = issues.not_sent.order(deliver_at: :asc).second

    if current_issue.nil?
      open_at = Date.current
      deliver_at = calculate_delivery_datetime(open_at)
      current_issue = generate_issue(open_at, deliver_at)
    end

    if next_issue.nil?
      open_at = current_issue.deliver_at
      deliver_at = calculate_delivery_datetime(open_at)
      generate_issue(open_at, deliver_at)
    end
  end

  def notify_club_of_delivery(issue)
      generate_issues
  end

  # Used for hiding respons from one member to another
  def visible_members(member)
    members.select { |m| member.can_see?(m) }
  end

  private

  def set_defaults
    self.sections ||= Club.sections
    self.delivery_frequency ||= 7 # weekly
    self.delivery_time ||= 8 # 8am
    self.delivery_day ||= 0 # Monday
    self.active ||= true
    self.default_number_questions ||= 1
    self.timezone ||= owner&.timezone || Time.zone.name
  end

  def generate_invite_code
    self.invite_code = SecureRandom.hex(12)
  end

  def update_live_issue
    issues.not_sent.each do |issue|
      issue.sections = active_sections
      issue.save!
    end
  end

  # Calculate the delivery datetime based on the start datetime and the delivery frequency
  # If the delivery frequency is weekly or more, deliver on the specified day of the week (+- the offset)
  # Otherwise, deliver every delivery_frequency days
  # For example if the delivery frequency is 7 (weekly) and the delivery day is 2 (Tuesday), and today is Monday, the next delivery datetime will be 8 days from today, the Tuesday after tomorrow.
  def calculate_delivery_datetime(from)
    from_in_timezone = from.in_time_zone(timezone)
    d_day = from_in_timezone.beginning_of_day + delivery_frequency.days
    d_day = adjust_to_delivery_day(d_day) if delivery_frequency >= 7

    d_day = d_day.change(hour: delivery_time)
    d_day = ensure_future_date(d_day)

    d_day
  end

  private

  # Adjust the date to the correct day of the week
  # If the date is not on the correct day of the week, look back up to 4 days to find the correct day
  # If no matching day is found, look forward from the date to find the next correct day
  # This ensures the delivery is always on the correct day of the week but not too far in the future when first created.
  def adjust_to_delivery_day(date)
    # Calculate the target day of the week (0-6, where 0 is Sunday)
    target_wday = delivery_day % 7

    # Check up to 4 days before the given date
    days_to_check = -4..0

    days_to_check.each do |offset|
      check_date = date + offset.days
      # If we find a date matching the target day of the week, return it
      return check_date if check_date.wday == target_wday
    end

    # If no matching day is found in the past 4 days,
    # calculate the next occurrence of the target day
    date + ((target_wday - date.wday) % 7).days
  end

  def ensure_future_date(date)
    date += delivery_frequency.days while date <= Time.current
    date
  end

  def recalculate_issue_dates
    issues = self.issues.not_sent.order(deliver_at: :asc)
    issues.each_with_index do |issue, index|
      if index == 0
        issue.update!(deliver_at: calculate_delivery_datetime(issue.open_at))
      else
        open_at = issues[index - 1].deliver_at
        issue.update!(
          open_at: open_at,
          deliver_at: calculate_delivery_datetime(open_at)
        )
      end
    end
  end

  def handle_active_change
    if active?
      generate_issues
    else
      issues.not_sent.destroy_all
    end
  end
end
