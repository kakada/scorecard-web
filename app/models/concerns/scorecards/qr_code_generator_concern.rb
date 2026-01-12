# frozen_string_literal: true

module Scorecards::QrCodeGeneratorConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    LOGO_PATH = Rails.root.join("public/csc_logo.png")

    after_commit :generate_qr_code, on: :update, if: -> { saved_change_to_progress? && open_voting? }

    def generate_qr_code
      return if qr_code.present?

      qr_png = QrCodeGenerator.new(
        value: voting_url,
        logo_url: LOGO_PATH.to_s
      ).call

      Tempfile.create(["scorecard_qr", ".png"]) do |file|
        file.binmode
        file.write(qr_png.to_s)
        file.rewind

        self.qr_code = file
        save!
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
        Rails.logger.error(
          "Failed to save QR code for Scorecard #{id || token}: " \
          "#{e.class} - #{e.message}"
        )
      end
    end

    def voting_url
      new_scorecard_vote_url(token, host: host)
    end

    private
      def host
        ENV.fetch("HOST_URL") { "localhost:3000" }
      end
  end
end
