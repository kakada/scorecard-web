# frozen_string_literal: true

class ScorecardQrCodeSerializer < ActiveModel::Serializer
  attributes :qr_code_url, :voting_url

  def voting_url
    Rails.application.routes.url_helpers.public_vote_url(
      object.uuid,
      host: Rails.application.config.action_mailer.default_url_options&[:host] || "localhost:3000"
    )
  end
end
