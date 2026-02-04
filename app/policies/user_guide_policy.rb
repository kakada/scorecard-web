# frozen_string_literal: true

class UserGuidePolicy < ApplicationPolicy
  def index?
    user.present?
  end
end
