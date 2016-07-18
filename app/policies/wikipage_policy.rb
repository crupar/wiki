class WikipagePolicy < ApplicationPolicy

  def wikipage
    record
  end

  def index?
    record.public? or user.premium? or user.admin?
  end

  def show?
    @wikipages = Wikipage.all
    return true if record.public?
    user.present? && (user.admin? || user.premium?)
  end

  def update?
    edit?
  end

  def edit?
    @wikipages = Wikipage.all
    
    return true if record.public?
    user.present? && (user.admin? || user.id == wikipage.user.id || user.premium? || FilterWikis.call(user, @wikipages))
  end

  def destroy?
    @wikipages = Wikipage.all
    return true if record.public?
    user.present? && (user.admin? || user.premium?)
  end


end
