# frozen_string_literal: true

class JaapPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def show?
    user.present?
  end

  def edit?
    user.present?
  end

  def update?
    edit?
  end
end
