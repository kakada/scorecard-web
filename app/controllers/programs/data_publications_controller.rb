# frozen_string_literal: true

module Programs
  class DataPublicationsController < ::ApplicationController
    def show
      @program = authorize current_program, :update?
      @data_publication = current_program.data_publication || current_program.build_data_publication

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
          data_publication_attributes: [
            :published_option
          ]
        )
      end
  end
end
