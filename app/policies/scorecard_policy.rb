# frozen_string_literal: true

class ScorecardPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if user.system_admin?
    return true if (user.program_admin? || user.staff?) && (user.program_id == record.program_id)
    return true if user.local_ngo_id == record.local_ngo_id
    false
  end

  def download?
    (user.program_id == record.program_id) && (create? || user.local_ngo_id == record.local_ngo_id)
  end

  def download_pdf?
    download? && record.access_locked?
  end

  def submit?
    download? && !record.access_locked?
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    create? && !record.access_locked?
  end

  def destroy?
    update? && !%w(running submitted).include?(record.progress)
  end

  def setting?
    user.program_admin? || user.staff? || user.lngo?
  end

  def request_change?
    user.lngo? || (create? && record.request_changes.length > 0)
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?
      return scope.where(local_ngo_id: user.local_ngo_id) if user.lngo?

      scope.where(program_id: user.program_id)
    end
  end
end
