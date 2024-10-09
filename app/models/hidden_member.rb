# Aka the divorce feature. Used to hide a member from the view of another member allowing groups to share responses with all but some members.
class HiddenMember < ApplicationRecord
  belongs_to :hider, class_name: "Member"
  belongs_to :hidden, class_name: "Member"

  validates :hider_id, uniqueness: { scope: :hidden_id }
  validate :cannot_hide_self

  private

  def cannot_hide_self
    errors.add(:base, "Cannot hide yourself") if hider_id == hidden_id
  end
end
