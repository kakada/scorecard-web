class ContactPolicy < ApplicationPolicy
  def index?
    user.system_admin?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def update?
    index?  
  end

  def destroy?
    index?
  end
end
