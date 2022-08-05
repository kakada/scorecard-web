# frozen_string_literal: true

module Scorecards::Lockable
  extend ActiveSupport::Concern

  included do
    validate :locked_scorecard, on: :update

    def lock_access!
      self.completed_at = Time.now.utc
      self.progress = Scorecard::STATUS_COMPLETED

      save(validate: false)
    end

    def lock_submit!
      self.submitted_at = Time.now.utc
      self.progress = Scorecard::STATUS_IN_REVIEW

      save(validate: false)
    end

    def completed_by(user)
      self.completor_id = user.id
      lock_access!

      push_notification_to_submitter_async
    end

    def unlock_access!
      update_columns(completed_at: nil, progress: Scorecard::STATUS_IN_REVIEW)
    end

    def access_locked?
      completed_at.present?
    end

    def submit_locked?
      submitted_at.present?
    end

    def push_notification_to_submitter_async
      return unless device_token.present?

      ScorecardPushNotificationWorker.perform_async(uuid)
    end

    def completed_scorecard_notification_message
      {
        data: {
          payload: {
            scorecard: {
              uuid: uuid,
              status: progress
            }
          }.to_json
        },
        notification: {
          title: I18n.t("scorecard.completed_scorecard"),
          body: I18n.t("scorecard.scorecard_is_checked", uuid: uuid)
        }
      }
    end

    private
      def locked_scorecard
        errors.add :base, I18n.t("scorecard.record_is_locked") if access_locked?
      end
  end
end
