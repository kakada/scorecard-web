# frozen_string_literal: true

module Programs
  class SettingsController < ::ApplicationController
    def show; end

    def update
      @program = authorize current_program

      if @program.update(program_params)
        redirect_to setting_path
      else
        redirect_to setting_path, alert: @program.errors.full_messages
      end
    end

    private
      def program_params
        params.require(:program).permit(
          :datetime_format, :enable_email_notification
        )
      end
  end
end
