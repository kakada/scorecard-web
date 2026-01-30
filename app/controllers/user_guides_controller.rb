# frozen_string_literal: true

class UserGuidesController < ApplicationController
  def index
    authorize :user_guide
    @user_guides = UserGuideService.new(current_user.role).available_guides
  end
end
