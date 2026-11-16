# frozen_string_literal: true

module Scorecards::PendingReviewReminderConcern
  extend ActiveSupport::Concern

  REMINDER_INTERVAL = 3.days

  included do
    def pending_review?
      in_review? && completed_at.nil? && submitted_at.present?
    end

    def schedule_pending_review_reminder
      PendingReviewReminderJob.perform_at(submitted_at + REMINDER_INTERVAL, id)
    end

    def reschedule_pending_review_reminder
      return unless pending_review?

      PendingReviewReminderJob.perform_at(next_pending_review_reminder_at, id)
    end

    def send_pending_review_reminder!
      return unless pending_review?

      elapsed_intervals = pending_review_elapsed_intervals
      notify_pending_review_reminder if elapsed_intervals.positive?

      PendingReviewReminderJob.perform_at(next_pending_review_reminder_at(elapsed_intervals), id)
    end

    private
      def pending_review_elapsed_intervals
        ((Time.current - submitted_at) / REMINDER_INTERVAL).floor
      end

      def next_pending_review_reminder_at(elapsed_intervals = pending_review_elapsed_intervals)
        submitted_at + (elapsed_intervals + 1) * REMINDER_INTERVAL
      end

      def notify_pending_review_reminder
        return unless program.enable_email_notification?

        recipients = [creator&.email, submitter&.email].compact_blank.uniq
        return if recipients.empty?

        NotificationMailer.pending_review_reminder(recipients, self).deliver_now
      end
  end
end
