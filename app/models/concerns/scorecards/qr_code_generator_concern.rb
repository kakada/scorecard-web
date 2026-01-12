# frozen_string_literal: true

module Scorecards::QrCodeGeneratorConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    LOGO_PATH = Rails.root.join("public/csc_logo.png")
    LOGO_PADDING = 12

    after_save :generate_qr_code, if: -> { saved_change_to_progress? && open_voting? }

    def generate_qr_code
      return if qr_code.present?

      qrcode = RQRCode::QRCode.new(
        voting_url,
        level: :h # REQUIRED when adding logo
      )

      qr_png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: ChunkyPNG::Color::BLACK,
        fill: ChunkyPNG::Color::WHITE,
        module_px_size: 6,
        size: 300
      )

      add_logo!(qr_png)

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
      def add_logo!(qr_png)
        return unless File.exist?(LOGO_PATH)

        logo = ChunkyPNG::Image.from_file(LOGO_PATH)

        # Resize logo to ~25% of QR width
        logo_size = (qr_png.width * 0.25).to_i
        logo = logo.resample_bilinear(logo_size, logo_size)

        # Add white padding behind logo
        background = ChunkyPNG::Image.new(
          logo.width + LOGO_PADDING,
          logo.height + LOGO_PADDING,
          ChunkyPNG::Color::WHITE
        )

        bg_x = (background.width - logo.width) / 2
        bg_y = (background.height - logo.height) / 2
        background.compose!(logo, bg_x, bg_y)

        # Center position
        x = (qr_png.width - background.width) / 2
        y = (qr_png.height - background.height) / 2

        qr_png.compose!(background, x, y)
      end

      def host
        ENV.fetch("HOST_URL") { "localhost:3000" }
      end
  end
end
