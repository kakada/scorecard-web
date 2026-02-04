# frozen_string_literal: true

module Scorecards
  class NormalizeParamsToUpdateService
    def initialize(scorecard, params)
      @scorecard = scorecard
      @params = params.deep_dup
    end

    def call
      normalize_voting_indicator_params
      params
    end

    private
      attr_reader :scorecard, :params

      def normalize_voting_indicator_params
        return unless voting_indicators_params.present?

        params[:voting_indicators_attributes] =
          voting_indicators_params.each_with_object([]) do |vi, memo|
            next memo << vi if vi[:id].present? || vi[:indicator_uuid].blank?

            existing = existing_by_uuid[vi[:indicator_uuid]]
            vi = vi.dup
            vi[:id] = existing.id if existing
            memo << vi
          end
      end

      def voting_indicators_params
        params[:voting_indicators_attributes]
      end

      def existing_by_uuid
        @existing_by_uuid ||= scorecard.voting_indicators.index_by(&:indicator_uuid)
      end
  end
end
