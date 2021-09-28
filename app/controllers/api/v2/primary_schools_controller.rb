# frozen_string_literal: true

module Api
  module V2
    class PrimarySchoolsController < ApiController
      skip_before_action :restrict_access

      def index
        @primary_schools = PrimarySchool.where(commune_id: params[:commune_id])

        render json: @primary_schools
      end
    end
  end
end
