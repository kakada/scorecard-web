# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::ScorecardProgress do
  describe "#group_count" do
    it "returns zero counts when scorecards is empty" do
      counts = described_class.new([]).group_count

      expect(counts.all).to eq(0)
      expect(counts.planned).to eq(0)
      expect(counts.running).to eq(0)
      expect(counts.in_review).to eq(0)
      expect(counts.completed).to eq(0)
    end

    it "counts scorecards by progress groups" do
      planned_progress = Scorecard::PLANNED_STATUSES.first
      running_progress = Scorecard::RUNNING_STATUSES.first

      scorecards = [
        instance_double(Scorecard, progress: planned_progress, in_review?: false, completed?: false),
        instance_double(Scorecard, progress: running_progress, in_review?: false, completed?: false),
        instance_double(Scorecard, progress: "in_review", in_review?: true, completed?: false),
        instance_double(Scorecard, progress: "completed", in_review?: false, completed?: true),
      ]

      counts = described_class.new(scorecards).group_count

      expect(counts.all).to eq(4)
      expect(counts.planned).to eq(1)
      expect(counts.running).to eq(1)
      expect(counts.in_review).to eq(1)
      expect(counts.completed).to eq(1)
    end
  end
end
