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
    (record.user -- user) || :record.collabarator.include?(user)
  end

  def destroy?
    @wikipages = Wikipage.all
    return true if record.public?
    user.present? && (user.admin? || user.premium?)
  end


end
