# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_progresses
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  status         :integer
#  device_id      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  conducted_at   :datetime
#
require "rails_helper"

RSpec.describe ScorecardProgress, type: :model do
  it { is_expected.to belong_to(:scorecard).with_foreign_key(:scorecard_uuid) }
  it { is_expected.to define_enum_for(:status).with_values({ downloaded: 1, running: 2, renewed: 3, open_voting: 4, close_voting: 5, in_review: 6, completed: 7 }) }

  describe "#after_save: set_scorecard_progress" do
    context "scorecard progress is smaller than scorecard_progress status" do
      let!(:scorecard) { create(:scorecard, progress: :downloaded) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, conducted_at: DateTime.yesterday, scorecard: scorecard) }

      it "set scorecard progress to downloaded" do
        expect(scorecard.reload.progress).to eq("running")
        expect(scorecard.reload.running_date).to eq(scorecard_progress.conducted_at)
        expect(scorecard.reload.runner_id).to eq(scorecard_progress.user_id)
      end
    end

    context "scorecard progress is not smaller than scorecard_progress status" do
      let!(:scorecard) { create(:scorecard, progress: :running) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :downloaded, scorecard: scorecard) }

      it "set scorecard progress to downloaded" do
        expect(scorecard.reload.progress).to eq("running")
      end
    end

    context "#renewed" do
      let!(:scorecard) { create(:scorecard, progress: :running) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :renewed, scorecard: scorecard) }

      it "sets scorecard progress to renewed" do
        expect(scorecard.reload.progress).to eq("renewed")
      end
    end

    context "scorecard is locked" do
      let!(:scorecard) { create(:scorecard, progress: :running) }
      let(:scorecard_progress) { build(:scorecard_progress, status: :completed, scorecard: scorecard) }

      before {
        scorecard.lock_access!
        scorecard_progress.save
      }

      it "set scorecard progress to completed" do
        expect(scorecard.reload.progress).to eq("completed")
      end
    end

    context "open_voting status updates scorecard progress" do
      let!(:scorecard) { create(:scorecard, progress: :running) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :open_voting, scorecard: scorecard) }

      it "sets scorecard progress to open_voting" do
        expect(scorecard.reload.progress).to eq("open_voting")
      end
    end

    context "close_voting status updates scorecard progress" do
      let!(:scorecard) { create(:scorecard, progress: :open_voting) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :close_voting, scorecard: scorecard) }

      it "sets scorecard progress to close_voting" do
        expect(scorecard.reload.progress).to eq("close_voting")
      end
    end
  end

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

  describe "#after_save update counter_cache" do
    context "downloaded" do
      let!(:scorecard) { create(:scorecard, downloaded_count: 0) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :downloaded, scorecard: scorecard) }

      it "increase downloaded_count by 1" do
        expect(scorecard.reload.downloaded_count).to eq(1)
      end
    end

    context "not downloaded" do
      let!(:scorecard) { create(:scorecard, downloaded_count: 0) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, scorecard: scorecard) }

      it "doesn't increase downloaded_count" do
        expect(scorecard.reload.downloaded_count).to eq(0)
      end
    end
  end

  describe "#after_destroy update counter_cache" do
    context "downloaded" do
      let!(:scorecard) { create(:scorecard, downloaded_count: 0) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :downloaded, scorecard: scorecard) }

      it "increase by 1 before destroy" do
        expect(scorecard.reload.downloaded_count).to eq(1)
      end

      it "decrease by 1 after destroy" do
        scorecard_progress.destroy
        expect(scorecard.reload.downloaded_count).to eq(0)
      end
    end

    context "not downloaded" do
      let!(:scorecard) { create(:scorecard, downloaded_count: 1) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, scorecard: scorecard) }

      it "doesn't update downloaded_count" do
        scorecard_progress.destroy
        expect(scorecard.reload.downloaded_count).to eq(1)
      end
    end
  end

  describe "#before_create set conducted_at" do
    context "having conducted_at" do
      let!(:scorecard) { create(:scorecard, progress: :downloaded) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, conducted_at: DateTime.yesterday, scorecard: scorecard) }

      it "doesn't reset conducted_at" do
        expect(scorecard_progress.conducted_at).not_to eq(scorecard_progress.created_at)
      end
    end

    context "having no conducted_at" do
      let!(:scorecard) { create(:scorecard, progress: :downloaded) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, conducted_at: nil, scorecard: scorecard) }

      it "set conducted_at as created_at" do
        expect(scorecard_progress.conducted_at).to eq(scorecard_progress.created_at)
      end
    end
  end
end
