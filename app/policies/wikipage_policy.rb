class WikipagePolicy < ApplicationPolicy

  def wikipage
    record
  end

  def show?
      (user.present? && (user.admin? || user.premium?)) && record.public?
  end

  def update?
    edit?
  end

  def edit?
    user.present? && (user.admin? || user.premium?)
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
