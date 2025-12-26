# frozen_string_literal: true

require "rails_helper"
require "samples/sandbox_seeder"

RSpec.describe Samples::SandboxSeeder, type: :service do
  subject(:seeder) { described_class.new }

  let(:sandbox_name) { described_class::SANDBOX_NAME }
  let(:facility_code) { described_class::FACILITY_CODE }
  let(:default_scorecard_code) { described_class::DEFAULT_SCORECARD_CODE }

  before do
    # Minimal data required for scorecard creation
    program = create(
      :program,
      name: "Sample Program", # NOT sandbox
      sandbox: false
    )

    facility = create(
      :facility,
      program: program,
      code: facility_code
    )

    category = create(:category, code: "DS_FA")
    facility.update!(category_id: category.id)

    create(:dataset, category: category)
  end

  describe "#load" do
    it "creates a sandbox program" do
      expect {
        seeder.load
      }.to change {
        Program.where(name: sandbox_name, sandbox: true).count
      }.by(1)
    end

    it "creates program scorecard types for the sandbox program" do
      expect {
        seeder.load
      }.to change {
        ProgramScorecardType.count
      }.by(ProgramScorecardType::TYPES.size)
    end

    it "creates a local NGO under the sandbox program" do
      seeder.load

      program = Program.find_by(name: sandbox_name)
      expect(program.local_ngos.exists?(name: sandbox_name)).to be(true)
    end

    it "creates demo CAFs for the local NGO" do
      seeder.load

      local_ngo = LocalNgo.find_by(name: sandbox_name)
      expect(local_ngo.cafs.pluck(:name))
        .to match_array(described_class::DEMO_CAF_NAMES)
    end

    it "creates and confirms an admin user" do
      seeder.load

      user = User.find_by(email: "admin@sandbox.org")

      expect(user).to be_present
      expect(user.role).to eq("program_admin")
      expect(user).to be_confirmed
      expect(user.program.name).to eq(sandbox_name)
    end

    it "creates and confirms an LNGO user" do
      seeder.load

      user = User.find_by(email: "lngo@sandbox.org")

      expect(user).to be_present
      expect(user.role).to eq("lngo")
      expect(user.local_ngo).to be_present
      expect(user).to be_confirmed
    end

    it "creates a sample scorecard with the default UUID" do
      seeder.load

      scorecard = Scorecard.find_by(uuid: default_scorecard_code)

      expect(scorecard).to be_present
      expect(scorecard.program.name).to eq(sandbox_name)
      expect(scorecard.local_ngo).to be_present
      expect(scorecard.creator).to be_present
    end
  end
end
