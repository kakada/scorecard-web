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
#
require "rails_helper"

RSpec.describe ScorecardProgress, type: :model do
  it { is_expected.to belong_to(:scorecard).with_foreign_key(:scorecard_uuid) }
  it { is_expected.to define_enum_for(:status).with_values({ downloaded: 1, running: 2, renewed: 4, in_review: 3, completed: 5 }) }

  describe "#after_save: set_scorecard_progress" do
    context "scorecard progress is smaller than scorecard_progress status" do
      let!(:scorecard) { create(:scorecard, progress: :downloaded) }
      let!(:scorecard_progress) { create(:scorecard_progress, status: :running, scorecard: scorecard) }

      it "set scorecard progress to downloaded" do
        expect(scorecard.reload.progress).to eq("running")
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
end
