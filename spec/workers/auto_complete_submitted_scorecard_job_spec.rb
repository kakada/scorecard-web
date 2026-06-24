# frozen_string_literal: true

require "rails_helper"

RSpec.describe AutoCompleteSubmittedScorecardJob do
  describe "#perform" do
    let(:program) { create(:program, enable_auto_complete_submitted_scorecard: true) }
    let(:scorecard) { create(:scorecard, :submitted, program: program) }
    let(:system_user) { create(:user, :system_admin) }

    before do
      allow(User).to receive(:system_user).and_return(system_user)
    end

    it "ignores missing scorecard" do
      expect { described_class.new.perform(-1) }.not_to raise_error
    end

    it "ignores completed scorecard" do
      scorecard.completed_by(create(:user))

      described_class.new.perform(scorecard.id)

      expect(scorecard.reload.completor).not_to eq(system_user)
    end

    it "ignores non-submitted scorecard" do
      non_submitted_scorecard = create(:scorecard, program: program)

      described_class.new.perform(non_submitted_scorecard.id)

      expect(non_submitted_scorecard.reload.completed?).to be(false)
    end

    it "ignores execution when feature disabled" do
      scorecard.program.update(enable_auto_complete_submitted_scorecard: false)

      described_class.new.perform(scorecard.id)

      expect(scorecard.reload.completed?).to be(false)
    end

    it "completes submitted scorecard when feature enabled" do
      described_class.new.perform(scorecard.id)

      expect(scorecard.reload.completed?).to be(true)
    end

    it "records system user as completer" do
      described_class.new.perform(scorecard.id)

      expect(scorecard.reload.completor).to eq(system_user)
    end
  end
end
