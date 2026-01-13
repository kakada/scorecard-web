# frozen_string_literal: true

class ScorecardQrCodeSerializer < ActiveModel::Serializer
  attributes :qr_code_url, :voting_url
end
