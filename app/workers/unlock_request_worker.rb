# frozen_string_literal: true

class UnlockRequestWorker
  include Sidekiq::Worker

  def perform(action, unlock_request_uuid)
    unlock_request = UnlockRequest.find(unlock_request_uuid)
    unlock_request.send(action.to_sym)

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message}"
  end
end
