# frozen_string_literal: true

module Scorecards
  class NormalizeParamsToUpdateService
    def initialize(scorecard, params)
      @scorecard = scorecard
      @params = params.deep_dup
    end

    def call
      normalize_voting_indicator_params
      normalize_participant_demographics_params
      params
    end

    private
      attr_reader :scorecard, :params

      def normalize_participant_demographics_params
        return unless scorecard.online?

        # merge results into params with integer coercion
        params.merge!(
          number_of_participant: participant_counts.total.to_i,
          number_of_female: participant_counts.female_count.to_i,
          number_of_disability: participant_counts.disability_count.to_i,
          number_of_ethnic_minority: participant_counts.minority_count.to_i,
          number_of_youth: participant_counts.youth_count.to_i,
          number_of_id_poor: participant_counts.poor_count.to_i
        )
      end

      def participant_counts
        @participant_counts ||= scorecard.participants
          .where(countable: true)
          .select(
            "COUNT(*) AS total",
            "SUM((gender = 'female')::int) AS female_count",
            "SUM(disability::int) AS disability_count",
            "SUM(minority::int) AS minority_count",
            "SUM(youth::int) AS youth_count",
            "SUM(poor_card::int) AS poor_count"
          )
          .take
      end

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
