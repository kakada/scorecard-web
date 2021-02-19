# frozen_string_literal: true

module Lockable
  extend ActiveSupport::Concern

  included do
    validate :locked_scorecard, on: :update

    def lock_access!
      self.locked_at = Time.now.utc
      save(validate: false)
    end

    def unlock_access!
      self.locked_at = nil
      save(validate: false)
    end

    def access_locked?
      !!locked_at
    end

    private
      def locked_scorecard
        errors.add :base, I18n.t("scorecard.record_is_locked") if access_locked?
      end
  end
end
