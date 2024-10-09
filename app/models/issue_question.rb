class IssueQuestion < ApplicationRecord
  belongs_to :issue
  has_many :answers, dependent: :destroy

  validates :prompt, presence: true
  validates :asked_by, presence: true
  validates :section, presence: true, inclusion: { in: Club.sections.map(&:to_s) }
  validates :kind, presence: true, inclusion: { in: %w[text select radio checkbox image] }

  scope :in_section, ->(section) { where(section: section) }
  scope :questions, -> { where(section: "questions") }
  scope :sections, -> { where.not(section: "questions") }

  before_validation :set_defaults

  def club
    issue.club
  end

  private

  def set_defaults
    self.section ||= "questions"
    self.asked_by ||= "System"
    self.kind ||= "text"
  end
end
