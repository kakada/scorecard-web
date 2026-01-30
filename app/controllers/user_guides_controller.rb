# frozen_string_literal: true

class UserGuidesController < ApplicationController
  # Define all available guides
  ALL_GUIDES = {
    system_admin: { file: 'system_admin_guide.pdf', key: 'system_admin' },
    program_admin: { file: 'program_admin_guide.pdf', key: 'program_admin' },
    staff: { file: 'staff_guide.pdf', key: 'staff' },
    lngo: { file: 'lngo_guide.pdf', key: 'lngo' },
    mobile_app: { file: 'mobile_app_guide.pdf', key: 'mobile_app' }
  }.freeze

  # Define which guides are available for each role
  ROLE_GUIDES = {
    system_admin: [:system_admin, :program_admin, :staff, :lngo, :mobile_app],
    program_admin: [:program_admin, :staff, :lngo, :mobile_app],
    staff: [:staff, :lngo, :mobile_app],
    lngo: [:lngo, :mobile_app]
  }.freeze

  def index
    @user_guides = available_guides
    authorize :user_guide
  end

  private
    def available_guides
      guide_keys = ROLE_GUIDES[current_user.role.to_sym] || []
      guide_keys.map { |key| ALL_GUIDES[key] }
    end
end
