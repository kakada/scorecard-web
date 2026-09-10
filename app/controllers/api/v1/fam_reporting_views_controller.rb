# frozen_string_literal: true

module Api
  module V1
    class FamReportingViewsController < ApiController
      skip_before_action :restrict_access, only: :create

      def create
        FamReportingStat.record_view!(:mobile)

        head :created
      end
    end
  end
end
