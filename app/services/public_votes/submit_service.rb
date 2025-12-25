# frozen_string_literal: true

module PublicVotes
  class SubmitService
    def initialize(form)
      @form = form
    end

    def call
      return false unless @form.save

      CalculateVotingResultsWorker.perform_async(@form.scorecard.id)
      true
    end
  end
end
