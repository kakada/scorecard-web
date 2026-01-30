# frozen_string_literal: true

class UnlockRequestWorker
  include Sidekiq::Worker

  ALLOWED_ACTIONS = %w[
    notify_unlock_request_to_program_admins
    notify_status_rejected_to_proposer
    notify_status_approved_to_proposer
  ].freeze

  def perform(action, unlock_request_uuid)
    unless ALLOWED_ACTIONS.include?(action)
      Rails.logger.error "Invalid action '#{action}' for UnlockRequestWorker"
      return
    end

    unlock_request = UnlockRequest.find(unlock_request_uuid)
    unlock_request.send(action.to_sym)

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message}"
  end
end
