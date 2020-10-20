# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApiController
      def index
        scorecard = Scorecard.find_by(uuid: params[:scorecard_id])

        render json: scorecard.languages
      end

      def download
        @language = ::Language.find_by(code: params[:id])

        send_file @language.json_file.path, disposition: "attachment"
      end
    end
  end
end
