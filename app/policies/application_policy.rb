class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user   = user
    @record = record
  end

  def index?
    record.public? or user.premium? or user.admin?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
#      user.present?
    false
  end

  def new?
#    create?
    false
  end

  def update?
#    user.present?
    false
  end

  def edit?
#    user.present?
    false
  end

  def destroy?
#    user.role == 'admin'
    false
  end


  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
