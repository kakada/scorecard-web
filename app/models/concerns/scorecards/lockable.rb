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

    def mark_as_completed!
      lock_access!
    end

    def unlock_access!
      self.completed_at = nil
      self.progress = Scorecard::STATUS_IN_REVIEW

      save(validate: false)
    end

    def access_locked?
      completed_at.present?
    end

    def submit_locked?
      submitted_at.present?
    end

    private
      def locked_scorecard
        errors.add :base, I18n.t("scorecard.record_is_locked") if access_locked?
      end
  end
end
