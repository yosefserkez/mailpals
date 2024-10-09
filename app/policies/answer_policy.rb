class AnswerPolicy < ApplicationPolicy
  def index?
    record.club.is_member?(user)
  end

  def update?
    record.club.can_manage?(user) || record.member.user == user
  end

  def show?
    record.club.is_member?(user) || record.member.user == user
  end

  def destroy?
    record.club.is_owner?(user) || record.member.user == user
  end

  def edit?
    update?
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  relation_scope do |relation|
    relation.joins(:club).where(club: { members: { user_id: user.id } })
  end
end
