class ClubPolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies

  def index?
    record.is_member?(user)
  end

  def update?
    record.can_manage?(user)
  end

  def show?
    record.is_member?(user)
  end

  def destroy?
    record.is_owner?(user)
  end

  def edit?
    update?
  end

  def manage?
    record.can_manage?(user)
  end

  def create?
    true
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  relation_scope do |relation|
    # next relation if user.admin?
    relation.joins(:members).where(members: { user_id: user.id })
  end
end
