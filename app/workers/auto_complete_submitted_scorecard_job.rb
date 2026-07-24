# frozen_string_literal: true

class AutoCompleteSubmittedScorecardJob
  include Sidekiq::Worker

  def perform(scorecard_id)
    scorecard = Scorecard.find_by(id: scorecard_id)
    return skip(scorecard_id) if scorecard.nil?
    return skip(scorecard.id) unless scorecard.program&.enable_auto_complete_submitted_scorecard?
    return skip(scorecard.id) if scorecard.completed? || !scorecard.in_review?

    system_user = User.system_user
    return skip(scorecard.id) if system_user.nil?

    Rails.logger.info("Auto-completing submitted scorecard #{scorecard.id}")
    scorecard.completed_by(system_user)
  end

  private
    def skip(scorecard_id)
      Rails.logger.info("Skipping auto-completion for scorecard #{scorecard_id}")
    end
end
