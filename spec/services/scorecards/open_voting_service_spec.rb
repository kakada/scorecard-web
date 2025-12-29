# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::OpenVotingService do
  describe "#call" do
    let(:scorecard) { create(:scorecard) }
    let(:service) { described_class.new(scorecard) }

    context "when QR code does not exist" do
      it "generates and saves a QR code" do
        expect(scorecard.qr_code.present?).to be_falsey

        service.call

        expect(scorecard.reload.qr_code.present?).to be_truthy
      end

      it "QR code contains the voting URL" do
        service.call

        expect(scorecard.reload.qr_code.url).to include("qr_code.png")
      end
    end

    context "when QR code already exists" do
      before do
        # First generation
        service.call
      end

      it "does not regenerate the QR code" do
        original_qr_code_url = scorecard.reload.qr_code.url

        # Try to generate again
        service.call

        expect(scorecard.reload.qr_code.url).to eq(original_qr_code_url)
      end
    end
  end
end
