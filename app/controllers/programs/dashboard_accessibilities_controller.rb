# frozen_string_literal: true

module Programs
  class DashboardAccessibilitiesController < ::ApplicationController
    def index
      @program = authorize current_program, :update?
      @emails = @program.users.where(role: [:staff, :lngo]).pluck(:email)

      respond_to do |format|
        format.js
      end
    end

    def upsert
      @program = authorize current_program, :update?

      if @program.update(program_params)
        redirect_to setting_path
      else
        respond_to do |format|
          format.js
        end
      end
    end

    private
      def program_params
        params.require(:program).permit(
          :dashboard_user_roles, :dashboard_user_emails
        )
      end
  end
end
