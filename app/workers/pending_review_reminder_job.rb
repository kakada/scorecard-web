# frozen_string_literal: true

class PendingReviewReminderJob
  include Sidekiq::Worker

  def perform(scorecard_id)
    scorecard = Scorecard.find_by(id: scorecard_id)
    return if scorecard.nil?

    scorecard.send_pending_review_reminder!
  end
end
