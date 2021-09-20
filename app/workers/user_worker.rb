# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker

  def perform(operation, user_id)
    user = User.find_by(id: user_id)

    return if user.nil?

    user.send(operation)
  end
end
