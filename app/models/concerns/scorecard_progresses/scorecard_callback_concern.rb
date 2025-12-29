# frozen_string_literal: true

module ScorecardProgresses::ScorecardCallbackConcern
  extend ActiveSupport::Concern

  included do
    after_save :set_scorecard_progress
    after_save :update_counter_cache, if: :downloaded?
    after_destroy :update_counter_cache, if: :downloaded?
    after_save :generate_qr_code, if: :open_voting?

    private
      def update_counter_cache
        scorecard.update_column(:downloaded_count, scorecard.scorecard_progresses.downloaded.count)
      end

      def set_scorecard_progress
        return if scorecard.in_review? || scorecard.completed?
        return if !scorecard.renewed? && self.class.statuses[scorecard.progress].to_i >= self.class.statuses[status].to_i

        scorecard.progress = status
        scorecard.attributes = scorecard.attributes.merge(scorecard_attributes[status]) if scorecard_attributes[status].present?
        scorecard.save(validate: false)
      end

      def scorecard_attributes
        {
          "running" => {
            "runner_id" => user_id,
            "running_date" => conducted_at
          }
        }
      end

      def generate_qr_code
        Scorecards::OpenVotingService.new(scorecard).call
      end
  end
end
