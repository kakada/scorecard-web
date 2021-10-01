# frozen_string_literal: true

module Programs
  class ContactsController < ::ApplicationController
    def index
      @program = authorize current_program, :update?

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
          contacts_attributes: [:id, :contact_type, :value, :_destroy]
        )
      end
  end
end
