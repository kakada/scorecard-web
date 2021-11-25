# frozen_string_literal: true

class RequestChangePolicy < ApplicationPolicy
  def create?
    user.lngo?
  end

  def edit?
    update? || review?
  end

  def update?
    record.proposer_id == user.id && record.submitted?
  end

  def review?
    (user.program_admin? || user.staff?) && record.submitted?
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
