# frozen_string_literal: true

module RequestChanges::CallbackNotification
  extend ActiveSupport::Concern

  included do
    after_create :notify_scorecard_request_change_to_creators_async
    after_save   :notify_status_rejected_to_proposer_async, if: -> { rejected? }
    after_save   :notify_status_approved_to_proposer_async, if: -> { approved? }

    def notify_scorecard_request_change_to_creators
      display_message = "There is a request change on the scorecard #{scorecard.uuid}. Reason: #{changed_reason}"

      send_mail(scorecard.creator.email, display_message)
    end

    def notify_status_rejected_to_proposer_async
      display_message = "Your request change on the scorecard #{scorecard.uuid} has been rejeted. Reason: #{rejected_reason}"

      send_mail(proposer.email, display_message)
    end

    def notify_status_approved_to_proposer
      display_message = "Your request change on the scorecard #{scorecard.uuid} has been approved."

      send_mail(proposer.email, display_message)
    end

    private
      # Async methods
      def notify_scorecard_request_change_to_creators_async
        RequestChangeWorker.perform_async("notify_scorecard_request_change_to_creators", id)
      end

      def notify_status_rejected_to_proposer_async
        RequestChangeWorker.perform_async("notify_status_rejected_to_proposer", id)
      end

      def notify_status_approved_to_proposer_async
        RequestChangeWorker.perform_async("notify_status_approved_to_proposer", id)
      end

      def send_mail(email, display_message)
        option = {
          scorecard: scorecard,
          request_change: self,
          body_message: display_message
        }

        NotificationMailer.notify_request_change(email, option).deliver_now
      end
  end
end
