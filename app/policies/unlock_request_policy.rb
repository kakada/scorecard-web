# frozen_string_literal: true

class UnlockRequestPolicy < ApplicationPolicy
  def create?
    user.lngo?
  end

  def edit?
    update? || review?
  end

  def update?
    record.proposer_id == user.id && record.pending?
  end

  def review?
    (user.program_admin? || user.staff?) && record.pending?
  end

  def approve?
    review?
  end

  def reject?
    review?
  end

  class Scope < Scope
    def resolve
      all
    end
  end
end
