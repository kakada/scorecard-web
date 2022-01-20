# frozen_string_literal: true

class ScorecardPushNotificationWorker
  include Sidekiq::Worker

  def perform(scorecard_uuid)
    scorecard = Scorecard.with_deleted.find_by(uuid: scorecard_uuid)

    return if scorecard.nil? || scorecard.device_token.blank?

    PushNotificationService.notify(
      [scorecard.device_token],
      scorecard.completed_scorecard_notification_message
    )
  end
end
