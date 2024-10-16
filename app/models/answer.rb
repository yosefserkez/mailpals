class Answer < ApplicationRecord
  belongs_to :member
  belongs_to :issue_question

  has_many :comments, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  validates :member_id, presence: true
  validates :issue_question_id, presence: true
  validates :member_id, uniqueness: { scope: :issue_question_id }
  validate :no_updates_after_delivery, on: :update

  scope :by_question, ->(question) { where(issue_question: question) }
  scope :by_member, ->(member) { where(member: member) }

  def unanswered?
    content.blank? && images.empty?
  end

  def self.member_answers(member)
    where(member: member)
  end

  def club
    issue_question.club
  end

  def issue
    issue_question.issue
  end

  private

  def no_updates_after_delivery
    if issue_question.issue.sent?
      errors.add(:base, "Cannot update answer after issue has been delivered")
    end
  end
end
