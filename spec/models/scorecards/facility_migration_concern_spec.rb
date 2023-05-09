# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::FacilityMigrationConcern do
  describe "#migrate" do
    let!(:facility_commune) { create(:facility, :commune) }
    let!(:scorecard) { create(:scorecard, :submitted, facility: facility_commune, program: facility_commune.program) }
    let!(:facility_ps) { create(:facility, :primary_school_with_dataset, program: scorecard.program) }
    let!(:dataset) { facility_ps.category.datasets.first }
    let!(:raised_indicator) { create(:raised_indicator, :custom, scorecard: scorecard) }

    describe "new facility" do
      context "when it is under different program" do
        let!(:scorecard) { create(:scorecard, :submitted, facility: facility_commune) }
        let!(:facility_commune2) { create(:facility, :commune) }

        it "raises error on facility doesn't in the same program" do
          scorecard.migrate_facility_to(facility_commune2.id, dataset.code)

          expect(scorecard.errors.full_messages).to include("Facility doesn't belong to the same program")
        end
      end

      context "when it is under the same program" do
        it "saves successfully" do
          scorecard.migrate_facility_to(facility_ps.id, dataset.code)

          expect(scorecard.reload.facility_id).to eq(facility_ps.id)
        end
      end
    end

    describe "raised indicators" do
      context "when raised_indicators are not all custom indicators" do
        let!(:scorecard) { create(:scorecard, :submitted, facility: facility_commune) }
        let!(:raised_indicator) { create(:raised_indicator, scorecard: scorecard) }

        it "raises error on raised indicator" do
          scorecard.migrate_facility_to(facility_ps.id, dataset.code)

          expect(scorecard.errors.full_messages).to include("Raised indicators must be all custom indicators")
        end
      end

      context "when raised_indicators are all custom indicators" do
        it "saves successfully" do
          scorecard.migrate_facility_to(facility_ps.id, dataset.code)

          expect(scorecard.reload.raised_indicators.length).to eq(1)
          expect(scorecard.reload.raised_indicators.map(&:indicator).all?(&:custom?)).to eq(true)
        end
      end
    end

    describe "scorecard progress" do
      context "when progress is not in review status" do
        let!(:scorecard) { create(:scorecard, :planned) }

        it "raises error on scorecard progress" do
          scorecard.migrate_facility_to(facility_ps.id, dataset.code)

          expect(scorecard.errors.full_messages).to include("Progress must be in review status")
        end
      end

      context "when progress is in review status" do
        let!(:scorecard) { create(:scorecard, :submitted, facility: facility_commune, program: facility_commune.program) }

        it "saves successfully" do
          scorecard.migrate_facility_to(facility_ps.id, dataset.code)

          expect(scorecard.reload.facility_id).to eq(facility_ps.id)
        end
      end
    end
  end
end
