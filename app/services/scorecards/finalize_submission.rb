# frozen_string_literal: true

# app/services/scorecards/finalize_submission.rb
module Scorecards
  class FinalizeSubmission
    def initialize(scorecard)
      @scorecard = scorecard
    end

    def call
      return if scorecard.submit_locked?

      ActiveRecord::Base.transaction do
        calculate_participant_demographics_if_online
        scorecard.lock_submit!
      end
    end

    private
      attr_reader :scorecard

      def calculate_participant_demographics_if_online
        return unless scorecard.online?

        participants = scorecard.participants.where(countable: true)

        scorecard.assign_attributes(
          number_of_participant: participants.count,
          number_of_female: participants.select { |p| p.gender == "female" }.count,
          number_of_disability: participants.select { |p| p.disability == true }.count,
          number_of_ethnic_minority: participants.select { |p| p.minority == true }.count,
          number_of_youth: participants.select { |p| p.youth == true }.count,
          number_of_id_poor: participants.select { |p| p.poor_card == true }.count
        )
      end
  end
end
