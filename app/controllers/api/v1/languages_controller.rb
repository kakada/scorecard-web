# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApiController
      def download
        @language = ::Language.find_by(code: params[:id])

        send_file @language.json_file.path, disposition: 'attachment'
      end
    end
  end
end
