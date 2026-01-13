# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::QrCodeGeneratorConcern, type: :model do
  describe "#after_save: generate_qr_code" do
    context "when status is open_voting" do
      let!(:scorecard) { create(:scorecard, progress: :running) }

      it "generates a QR code for the scorecard" do
        expect(scorecard.qr_code.present?).to be_falsey

        create(:scorecard_progress, status: :open_voting, scorecard: scorecard)

        expect(scorecard.reload.qr_code.present?).to be_truthy
      end
    end

    context "when status is not open_voting" do
      let!(:scorecard) { create(:scorecard, progress: nil) }

      it "does not generate a QR code" do
        create(:scorecard_progress, status: :downloaded, scorecard: scorecard)

        expect(scorecard.reload.qr_code.present?).to be_falsey
      end
    end
  end
end
