# frozen_string_literal: true

require "rails_helper"

RSpec.describe ScorecardsHelper, type: :helper do
  describe "#status_html" do
    let(:planned_scorecard) { build(:scorecard) }

    it "#status_planned_html" do
      expect(helper).to receive(:status_planned_html).with("planned")
      helper.status_html(planned_scorecard)
    end

    it "#status_renewed_html" do
      planned_scorecard.progress = "renewed"
      expect(helper).to receive(:status_renewed_html).with("renewed")
      helper.status_html(planned_scorecard)
    end

    it "#status_running_html" do
      planned_scorecard.progress = "running"
      expect(helper).to receive(:status_running_html).with("running")
      helper.status_html(planned_scorecard)
    end

    it "#status_completed_html" do
      planned_scorecard.progress = "completed"
      expect(helper).to receive(:status_completed_html).with("completed")
      helper.status_html(planned_scorecard)
    end
  end
end
