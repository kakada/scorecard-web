# frozen_string_literal: true

module Programs
  class TelegramBotsController < ::ApplicationController
    def show
      @telegram_bot = current_program.telegram_bot || current_program.build_telegram_bot

      respond_to do |format|
        format.js
      end
    end

    def upsert
      @program = current_program

      if @program.update(program_params)
        redirect_to setting_path
      else
        respond_to do |format|
          format.js
        end
      end
    end

    def help; end

    private
      def program_params
        params.require(:program).permit(
          telegram_bot_attributes: [
            :token, :username, :enabled
          ]
        )
      end
  end
end
