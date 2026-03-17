# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::Filter do
  describe "Scorecard filtering" do
    describe ".filter_by_uuid" do
      let!(:match) { create(:scorecard, uuid: "ABC123") }
      let!(:non_match) { create(:scorecard, uuid: "ZZZ999") }

      it "returns records whose uuid contains the query" do
        result = Scorecard.filter(uuid: "ABC")
        expect(result).to match_array([match])
      end

      it "returns all when uuid is blank" do
        result = Scorecard.filter(uuid: nil)
        expect(result).to include(match, non_match)
      end
    end

    describe ".filter_by_date_range" do
      let!(:in_range) do
        create(:scorecard, planned_start_date: Time.zone.local(2026, 1, 15))
      end

      let!(:out_of_range) do
        create(:scorecard, planned_start_date: Time.zone.local(2026, 2, 1))
      end

      it "returns records within the planned_start_date range (inclusive)" do
        result = Scorecard.filter(
          start_date: Date.new(2026, 1, 1),
          end_date: Date.new(2026, 1, 31)
        )

        expect(result).to match_array([in_range])
      end

      it "returns all when either bound is missing" do
        expect(Scorecard.filter(start_date: nil, end_date: Date.new(2026, 1, 31))).to include(in_range, out_of_range)
        expect(Scorecard.filter(start_date: Date.new(2026, 1, 1), end_date: nil)).to include(in_range, out_of_range)
      end
    end

    describe ".filter_by_progress" do
      let!(:nil_progress) { create(:scorecard, progress: nil) }
      let!(:planned) { create(:scorecard, progress: "planned") }
      let!(:renewed) { create(:scorecard, progress: "renewed") }
      let!(:downloaded) { create(:scorecard, progress: "downloaded") }
      let!(:running) { create(:scorecard, progress: "running") }
      let!(:open_voting) { create(:scorecard, progress: "open_voting") }
      let!(:close_voting) { create(:scorecard, progress: "close_voting") }
      let!(:completed) { create(:scorecard, progress: "completed") }

      it "treats 'planned' filter as planned_statuses" do
        result = Scorecard.filter(filter: "planned")
        expect(result).to match_array([planned, renewed, downloaded])
      end

      it "treats 'running' filter as running_statuses" do
        result = Scorecard.filter(filter: "running")
        expect(result).to match_array([running, open_voting, close_voting])
      end

      it "filters by exact progress for other values" do
        result = Scorecard.filter(filter: "completed")
        expect(result).to match_array([completed])
      end

      it "returns all when filter is blank" do
        result = Scorecard.filter(filter: nil)
        expect(result).to include(nil_progress, planned, renewed, downloaded, running, open_voting, close_voting, completed)
      end
    end

    describe ".filter" do
      it "combines multiple filters" do
        target = create(:scorecard, uuid: "HELLO-001", progress: "running", planned_start_date: Time.zone.local(2026, 3, 10))
        _other_same_uuid = create(:scorecard, uuid: "HELLO-002", progress: "planned", planned_start_date: Time.zone.local(2026, 3, 10))
        _other_same_progress = create(:scorecard, uuid: "BYE-001", progress: "running", planned_start_date: Time.zone.local(2026, 3, 10))

        result = Scorecard.filter(
          uuid: "HELLO",
          filter: "running",
          start_date: Date.new(2026, 3, 1),
          end_date: Date.new(2026, 3, 31)
        )

        expect(result).to match_array([target])
      end

      it "filters by facility_ids" do
        facility1 = create(:facility, :with_parent)
        facility2 = create(:facility, :with_parent)

        s1 = create(:scorecard, facility: facility1, unit_type_id: facility1.parent_id)
        _s2 = create(:scorecard, facility: facility2, unit_type_id: facility2.parent_id)

        result = Scorecard.filter(facility_ids: [facility1.id])
        expect(result).to match_array([s1])
      end
    end
  end
end
