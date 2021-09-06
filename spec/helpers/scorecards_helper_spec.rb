# frozen_string_literal: true

require "rails_helper"

RSpec.describe ScorecardsHelper, type: :helper do
  describe "#status_html" do
    let(:planned_scorecard) { build(:scorecard) }
    let(:completed_scorecard) { build(:scorecard, progress: 'submitted') }

    it "#status_planned_html" do
      expect(helper).to receive(:status_planned_html).with('planned')
      helper.status_html(planned_scorecard)
    end

    it "#status_planned_renewed_html" do
      planned_scorecard.progress = 'renewed'
      expect(helper).to receive(:status_planned_renewed_html).with('planned')
      helper.status_html(planned_scorecard)
    end

    it "#status_planned_running_html" do
      planned_scorecard.progress = 'running'
      expect(helper).to receive(:status_planned_running_html).with('planned')
      helper.status_html(planned_scorecard)
    end

    it "#status_completed_submitted_html" do
      completed_scorecard.locked_at = DateTime.current
      expect(helper).to receive(:status_completed_submitted_html).with('completed')
      helper.status_html(completed_scorecard)
    end
  end
end
