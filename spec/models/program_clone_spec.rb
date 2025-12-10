# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramClone, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:target_program).class_name("Program") }
    it { is_expected.to belong_to(:source_program).class_name("Program").optional }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    let(:program_clone) { build(:program_clone) }

    it { is_expected.to validate_presence_of(:clone_method) }
    it { is_expected.to validate_inclusion_of(:clone_method).in_array(ProgramClone::CLONE_METHODS) }
    it { is_expected.to validate_presence_of(:selected_components) }

    context "when clone_method is 'program'" do
      subject { create(:program_clone, :from_program) }

      it "is valid with source_program_id" do
        expect(subject).to be_valid
      end

      it "is invalid without source_program_id" do
        subject.source_program_id = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:source_program_id]).to include("must be present when clone method is 'program'")
      end
    end

    context "when clone_method is 'sample'" do
      subject { build(:program_clone) }

      it "is valid without source_program_id" do
        expect(subject).to be_valid
      end
    end

    context "with invalid components" do
      subject { build(:program_clone, selected_components: ["invalid_component"]) }

      it "is invalid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:selected_components]).to include("contains invalid components: invalid_component")
      end
    end
  end

  describe "scopes" do
    let!(:pending_clone) { create(:program_clone, status: "pending") }
    let!(:processing_clone) { create(:program_clone, status: "processing") }
    let!(:completed_clone) { create(:program_clone, status: "completed") }
    let!(:failed_clone) { create(:program_clone, status: "failed") }

    describe ".pending" do
      it "returns only pending clones" do
        expect(ProgramClone.pending).to contain_exactly(pending_clone)
      end
    end

    describe ".processing" do
      it "returns only processing clones" do
        expect(ProgramClone.processing).to contain_exactly(processing_clone)
      end
    end

    describe ".completed" do
      it "returns only completed clones" do
        expect(ProgramClone.completed).to contain_exactly(completed_clone)
      end
    end

    describe ".failed" do
      it "returns only failed clones" do
        expect(ProgramClone.failed).to contain_exactly(failed_clone)
      end
    end
  end

  describe "instance methods" do
    describe "#clone_from_sample?" do
      it "returns true when clone_method is 'sample'" do
        program_clone = build(:program_clone, clone_method: "sample")
        expect(program_clone.clone_from_sample?).to be true
      end

      it "returns false when clone_method is 'program'" do
        program_clone = build(:program_clone, :from_program)
        expect(program_clone.clone_from_sample?).to be false
      end
    end

    describe "#clone_from_program?" do
      it "returns true when clone_method is 'program'" do
        program_clone = build(:program_clone, :from_program)
        expect(program_clone.clone_from_program?).to be true
      end

      it "returns false when clone_method is 'sample'" do
        program_clone = build(:program_clone, clone_method: "sample")
        expect(program_clone.clone_from_program?).to be false
      end
    end

    describe "status methods" do
      it "#pending? returns true for pending status" do
        expect(build(:program_clone, status: "pending").pending?).to be true
      end

      it "#processing? returns true for processing status" do
        expect(build(:program_clone, status: "processing").processing?).to be true
      end

      it "#completed? returns true for completed status" do
        expect(build(:program_clone, status: "completed").completed?).to be true
      end

      it "#failed? returns true for failed status" do
        expect(build(:program_clone, status: "failed").failed?).to be true
      end
    end
  end
end
