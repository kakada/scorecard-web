# frozen_string_literal: true

module Programs
  class ContactsController < ::ApplicationController
    def index
      @program = current_program

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

    private
      def program_params
        params.require(:program).permit(
          contacts_attributes: [:id, :contact_type, :value, :_destroy]
        )
      end
  end
end
