# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestLogParser do
  describe "#parse" do
    let(:parser) { described_class.parse(data) }

    context "with whitelist attributes" do
      let(:data) { { controller: "TestController" } }

      specify { expect(parser).to have_key(:controller) }
    end

    context "without whitelist attributes" do
      let(:data) { { bad_key: "BadKey" } }

      specify { expect(parser).not_to have_key(:bad_key) }
    end

    context "with payload" do
      let(:data) { { params: { controller: "TestController", action: "test", start_date: "01/02/2021" } } }

      specify { expect(parser).to have_key(:start_date) }
      specify { expect(parser).not_to have_key(:controller) }
      specify { expect(parser).not_to have_key(:action) }
    end
  end
end
