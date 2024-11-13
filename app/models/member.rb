class Member < ApplicationRecord
  belongs_to :user
  belongs_to :club

  has_many :hidden_member_relations, class_name: "HiddenMember", foreign_key: "hider_id", dependent: :destroy
  has_many :hidden_members, through: :hidden_member_relations, source: :hidden
  accepts_nested_attributes_for :hidden_member_relations, allow_destroy: true, reject_if: :all_blank

  delegate :email, to: :user

  # TODO: Positional arguments should be used instead. Breaking change
  enum :role, { member: 0, admin: 1, owner: 2 }

  validates :user_id, uniqueness: { scope: :club_id, message: "is already a member of this club" }
  validate :ensure_one_owner, if: :role_changed?

  before_create :set_defaults

  attr_accessor :user_email

  scope :active, -> { where.not(activated_at: nil) }

  def name
    display_name
  end

  def first_name
    display_name.split.first
  end

  def admin?
    role == "admin"
  end

  def owner?
    role == "owner"
  end

  def can_manage?
    role == "owner" || role == "admin"
  end

  def last_owner?
    club.members.where(role: :owner).count == 1
  end

  def email
    user_email
  end

  def user_email
    user&.email
  end

  def accept_invitation
    self.activated_at = DateTime.current
    save!
  end

  def active?
    activated_at.present?
  end

  def status
    if active?
      "Active"
    else
      invitation_sent_at.present?
      "Invited"
    end
  end

  def hidden?(other_member)
    hidden_members.include?(other_member)
  end

  def can_see?(other_member)
    !hidden?(other_member) && (other_member.active? || self.can_manage?)
  end

  def hidden_member_ids=(ids)
    ids = ids.reject(&:blank?).map(&:to_i)
    self.hidden_member_relations = ids.map { |id| HiddenMember.new(hidden_id: id) }
  end

  private

  def set_defaults
    self.role ||= :member
    self.display_name ||= user.name
  end

  def ensure_one_owner
    if role_was == "owner" && role != "owner" && club.members.where(role: :owner).count == 1
      errors.add(:role, "can't be changed. There must be at least one owner.")
    end
  end
end
