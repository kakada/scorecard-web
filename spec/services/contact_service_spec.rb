# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactService do
  context "with program" do
    subject { described_class.new(program) }

    let(:program) { create(:program) }
    let(:contact) { create(:contact, program: program) }

    it "#as_json" do
      expect(subject.as_json).to eq [contact]
    end
  end

  context "without program" do
    subject { described_class.new(nil) }

    let(:contact) { create(:contact, program: nil) }

    it "#as_json" do
      expect(subject.as_json).to eq [contact]
    end
  end
end
