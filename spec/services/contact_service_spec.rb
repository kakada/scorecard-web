require 'rails_helper'

RSpec.describe ContactService do
  

  context "with program" do
    let(:program) { create(:program) }
    let!(:contact_with_program) { create(:contact, program: program) }

    it "#as_json" do
      expect(described_class.new(program).as_json).to eq [contact_with_program]
    end
  end

  context "without program" do
    let!(:contact_without_program) { create(:contact, program: nil) }

    it "#as_json" do
      expect(described_class.new(nil).as_json).to eq [contact_without_program]
    end
  end
end
