# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker

  def perform(operation, user_id)
    user = User.find_by(id: user_id)

    return if user.nil? || ENV['GF_DASHBOARD_URL'].blank?

    user.send(operation)
  end
end
