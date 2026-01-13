# frozen_string_literal: true

require "rails_helper"

RSpec.describe QrCodeImageGenerator do
  describe "#call" do
    let(:value) { "https://example.com/path?q=1" }

    context "without logo" do
      it "returns a PNG image with expected dimensions" do
        image = described_class.new(value: value).call
        expect(image).to be_a(ChunkyPNG::Image)
        expect(image.width).to eq(300)
        expect(image.height).to eq(300)
      end
    end

    context "with existing logo file" do
      let(:tmpdir) { Dir.mktmpdir }
      let(:logo_path) { File.join(tmpdir, "logo.png") }
      let(:red_color) { ChunkyPNG::Color.rgb(255, 0, 0) }

      before do
        # Create a solid red square logo to make center pixel assertion deterministic
        logo = ChunkyPNG::Image.new(100, 100, red_color)
        logo.save(logo_path)
      end

      after do
        FileUtils.remove_entry(tmpdir) if File.exist?(logo_path)
      end

      it "composes the logo at the center over a white background" do
        image = described_class.new(value: value, logo_url: logo_path).call
        expect(image).to be_a(ChunkyPNG::Image)
        expect(image.width).to eq(300)
        expect(image.height).to eq(300)

        center_color = image[image.width / 2, image.height / 2]
        expect(center_color).to eq(red_color)
      end
    end

    context "with non-existent logo file" do
      it "returns the QR image without raising" do
        image = described_class.new(value: value, logo_url: "/path/does/not/exist.png").call
        expect(image).to be_a(ChunkyPNG::Image)
        expect(image.width).to eq(300)
        expect(image.height).to eq(300)
      end
    end
  end
end
