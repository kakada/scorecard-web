# frozen_string_literal: true

module UnlockRequests::CallbackNotification
  extend ActiveSupport::Concern

  included do
    after_create :notify_unlock_request_to_program_admins_async
    after_save   :notify_status_rejected_to_proposer_async, if: -> { rejected? && saved_change_to_status? }
    after_save   :notify_status_approved_to_proposer_async, if: -> { approved? && saved_change_to_status? }

    def notify_unlock_request_to_program_admins
      program_admin_emails = scorecard.program.users.where(role: User.roles[:program_admin]).pluck(:email)
      return if program_admin_emails.empty?

      display_message = "A request to unlock scorecard #{scorecard.uuid} has been submitted by #{proposer.email}. Reason: #{reason}"

      send_mail(program_admin_emails, display_message)
    end

    def notify_status_rejected_to_proposer
      display_message = "Your request to unlock scorecard #{scorecard.uuid} has been rejected. Reason: #{rejected_reason}"

      send_mail(proposer.email, display_message)
    end

    def notify_status_approved_to_proposer
      display_message = "Your request to unlock scorecard #{scorecard.uuid} has been approved. The scorecard is now available for review."

      send_mail(proposer.email, display_message)
    end

    private
      # Async methods
      def notify_unlock_request_to_program_admins_async
        UnlockRequestWorker.perform_async("notify_unlock_request_to_program_admins", id)
      end

      def notify_status_rejected_to_proposer_async
        UnlockRequestWorker.perform_async("notify_status_rejected_to_proposer", id)
      end

      def notify_status_approved_to_proposer_async
        UnlockRequestWorker.perform_async("notify_status_approved_to_proposer", id)
      end

      def send_mail(email, display_message)
        option = {
          scorecard: scorecard,
          unlock_request: self,
          body_message: display_message
        }

        NotificationMailer.notify_unlock_request(email, option).deliver_now
      end
  end
end
