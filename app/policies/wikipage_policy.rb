class WikipagePolicy < ApplicationPolicy

  def wikipage
    record
  end

  def show?
    return true if record.public?
      user.present? && (user.admin? || user.premium?)
  end

  def update?
    edit?
  end

  def edit?
    (record.user == user) || record.users.include?(user)
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def destroy?
    user.admin?
  end


end
