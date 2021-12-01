# frozen_string_literal: true

class RequestChangeWorker
  include Sidekiq::Worker

  def perform(action, request_change_uuid)
    request_change = RequestChange.find(request_change_uuid)
    request_change.send(action.to_sym)

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message}"
  end
end
