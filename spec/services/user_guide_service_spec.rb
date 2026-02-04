# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGuideService do
  describe "#available_guides" do
    def guide_keys_for(role)
      described_class.new(role).available_guides.map { |g| g[:key].to_s }
    end

    it "returns guides for system_admin in correct order" do
      expect(guide_keys_for(:system_admin)).to eq(%w[system_admin program_admin staff lngo mobile_app])
    end

    it "returns guides for program_admin in correct order" do
      expect(guide_keys_for(:program_admin)).to eq(%w[program_admin staff lngo mobile_app])
    end

    it "returns guides for staff in correct order" do
      expect(guide_keys_for(:staff)).to eq(%w[staff lngo mobile_app])
    end

    it "returns guides for lngo in correct order" do
      expect(guide_keys_for(:lngo)).to eq(%w[lngo mobile_app])
    end

    it "returns empty array for unknown role" do
      expect(guide_keys_for(:unknown)).to eq([])
    end

    it "accepts string role and coerces to symbol" do
      expect(guide_keys_for("system_admin")).to eq(%w[system_admin program_admin staff lngo mobile_app])
    end

    it "returns full guide hashes with file and key" do
      guides = described_class.new(:staff).available_guides
      expect(guides).to all(include(:file, :key))
      # spot-check the first guide mapping
      expect(guides.first[:key]).to eq("staff")
      expect(guides.first[:file]).to eq("staff_guide.pdf")
    end
  end
end
