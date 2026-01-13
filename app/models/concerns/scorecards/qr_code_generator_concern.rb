# frozen_string_literal: true

module Scorecards::QrCodeGeneratorConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    LOGO_PATH = Rails.root.join("public/csc_logo.png")

    after_commit :generate_qr_code, on: :update, if: -> { saved_change_to_progress? && open_voting? }

    def generate_qr_code
      return if qr_code.present?

      qr_png = QrCodeImageGenerator.new(
        value: voting_url,
        logo_url: LOGO_PATH.to_s
      ).call

      Tempfile.create(["scorecard_qr", ".png"]) do |file|
        file.binmode              # treat file as raw bytes
        file.write(qr_png.to_s)   # write PNG bytes

        # Why it is required?
        # After write, the file pointer is at the end.
        # If you pass this file to something else (e.g. CarrierWave, ActiveStorage):
        # That system will try to read from the current position.
        # Without rewind: It starts reading at EOF and result to empty or corrupted upload
        file.rewind               # reset pointer for reading

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
