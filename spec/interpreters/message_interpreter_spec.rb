# frozen_string_literal: true

require "rails_helper"

RSpec.describe MessageInterpreter do
  describe "interpreted_message" do
    let(:scorecard) { create(:scorecard) }
    let(:message_content) {
      "Scorecard {{scorecard.uuid}}({{scorecard.facility_name}}) in {{scorecard.location_name}} is being downloaded by {{scorecard.local_ngo_name}} on {{scorecard.planned_end_date}}"
    }

    context "no scorecard" do
      let(:interpreter) { MessageInterpreter.new(nil, message_content) }

      it "doen't interpret message" do
        expect(interpreter.interpreted_message).to eq(message_content)
      end
    end

    context "invalid template code" do
      let(:interpreter) { MessageInterpreter.new(scorecard, invalid_message_content) }

      context "wrong curly brackets" do
        let(:invalid_message_content) { "Scorecard {{scorecard.uuid" }

        it "doen't interpret message" do
          expect(interpreter.interpreted_message).to eq(invalid_message_content)
        end
      end

      context "wrong field_code" do
        let(:invalid_message_content) { "Scorecard {{scorecard.test_field}}" }

        it "returns nil for wrong field" do
          expect(interpreter.interpreted_message).to eq("Scorecard ")
        end
      end
    end

    context "valid template code" do
      let(:display_message) {
        "Scorecard <b>#{scorecard.uuid}</b>(<b>#{scorecard.facility_name}</b>) in <b>#{scorecard.location_name}</b> is being downloaded by <b>#{scorecard.local_ngo_name}</b> on <b>#{I18n.l(scorecard.planned_end_date)}</b>"
      }
      let(:interpreter) { MessageInterpreter.new(scorecard, message_content) }

      it { expect(interpreter.interpreted_message).to eq(display_message) }
    end
  end
end
