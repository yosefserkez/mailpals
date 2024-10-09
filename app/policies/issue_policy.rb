class IssuePolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies
  #
  def index?
    record.club.is_member?(user) || user.super_admin?
  end

  def update?
    record.club.can_manage?(user) || user.super_admin?
  end

  def show?
    record.club.is_member?(user) || user.super_admin?
  end

  def destroy?
    record.club.is_owner?(user) || user.super_admin?
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
