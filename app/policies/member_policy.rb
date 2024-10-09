class MemberPolicy < ApplicationPolicy
  def index?
    record.club.is_member?(user) || user.super_admin?
  end

  def update?
    record.club.can_manage?(user) || record.user == user || user.super_admin?
  end

  def show?
    record.club.is_member?(user) || user.super_admin?
  end

  def destroy?
    (record.club.can_manage?(user) && !record.owner?) || user.super_admin?
  end

  # def create?
  #   update?
  # end

  # def update?
  #   record.club.can_manage?(user)
  # end
  #
  # def show?
  #   record.club.membership(user)
  # end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  relation_scope do |relation|
    # next relation if user.admin?
    relation.joins(:club).where(club: { members: { user_id: user.id } })
  end
end
