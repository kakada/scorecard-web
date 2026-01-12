# frozen_string_literal: true

class QrCodeGenerator
  LOGO_PADDING = 12

  attr_reader :value, :logo_url

  def initialize(value:, logo_url: nil)
    @value = value
    @logo_url = logo_url
  end

  def call
    qrcode = RQRCode::QRCode.new(
      value,
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

    add_logo!(qr_png) if logo_url

    qr_png
  end

  private
    def add_logo!(qr_png)
      return unless File.exist?(logo_url)

      logo = ChunkyPNG::Image.from_file(logo_url)

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
end
