# frozen_string_literal: true

class ScorecardQrCodeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :qr_code_url, :voting_url

  def voting_url
    new_scorecard_vote_url(object.token, host: host)
  end

  private
    def host
      ENV.fetch("HOST_URL") { "localhost:3000" }
    end
end
