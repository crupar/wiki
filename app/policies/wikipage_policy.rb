class WikipagePolicy < ApplicationPolicy

  def index?
    return true unless record.private?
    if record.private?
      return false unless user.premium? || user.admin?
    end
end

def show?
  return true unless record.private?
  user.present? && (user.admin? || user.premium?)
end

  def create?
    return user.present?
    if record.private?
      user.present? && (user.admin? || user.premium?)
    end
    end

  def new?
    show?
  end

  def update?
    return false unless user.present?
    if record.private?
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
