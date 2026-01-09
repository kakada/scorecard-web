# frozen_string_literal: true

require "rqrcode"
require "chunky_png"

module Scorecards
  class OpenVotingService
    attr_reader :scorecard

    include Rails.application.routes.url_helpers

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def call
      generate_qr_code
    end

    def voting_url
      public_vote_url(scorecard.uuid, host: host)
    end

    private
      def generate_qr_code
        return if scorecard.qr_code.present?

        qr_code_value = voting_url
        qrcode = RQRCode::QRCode.new(qr_code_value)

        # Generate PNG image from QR code
        png = qrcode.as_png(
          bit_depth: 1,
          border_modules: 4,
          color_mode: ChunkyPNG::COLOR_GRAYSCALE,
          color: "black",
          file: nil,
          fill: "white",
          module_px_size: 6,
          resize_exactly_to: false,
          resize_gte_to: false,
          size: 300
        )

        # Save QR code to scorecard via CarrierWave
        Tempfile.create(["scorecard_qr", ".png"]) do |file|
          file.binmode
          file.write(png.to_s)
          file.rewind

          begin
            scorecard.qr_code = file
            scorecard.save!
          rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
            Rails.logger.error(
              "Failed to save QR code for Scorecard #{scorecard.id || scorecard.uuid}: " \
              "#{e.class} - #{e.message}"
            )
          end
        end
      end

      def host
        ENV.fetch("HOST_URL") { "localhost:3000" }
      end
  end
end
