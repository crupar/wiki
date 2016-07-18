class WikipagePolicy < ApplicationPolicy

def index?
  record.public? or user.premium? or user.admin?
end

def show?
  return true if record.public?
  user.present? && (user.admin? || user.premium?)
end

def create?
  return false unless user.present?
  if record.public?
    return false if user.premium? || user.admin? || record.user == user
  end
  user.admin? || record.user == user
end

  def new?
    user.present?
  end

  def update?
    return false unless user.present?
    if record.public?
      return false unless user.premium? || user.admin? || record.user == user
    end
    user.admin? || record.user == user
  end


  def edit?
    show?
  end

  def destroy?
    user.admin?
  end






  class Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
    #    (scope.private_wikipages + scope.shared_wikipages(user) + scope.personal_wikipages(user)).uniq
      end
    end
  end


end
