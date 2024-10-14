class IssuePolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies
  #
  def index?
    record.club.is_member?(user)
  end

  def update?
    record.club.can_manage?(user)
  end

  def show?
    record.club.is_member?(user)
  end

  def destroy?
    record.club.is_owner?(user)
  end

  def edit?
    update?
  end

  def deliver?
    record.club.can_manage?(user)
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  relation_scope do |relation|
    relation.joins(:club).where(club: { members: { user_id: user.id } })
  end
end
