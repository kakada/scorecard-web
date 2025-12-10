# frozen_string_literal: true

require "rails_helper"

RSpec.describe CloneWizardWorker do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:target_program) { create(:program) }

    context "when cloning from sample" do
      let(:program_clone) { create(:program_clone, target_program: target_program, user: user, status: "pending") }
      let(:service) { instance_double(WizardProgramService) }

      before do
        allow(WizardProgramService).to receive(:new).with(target_program.id, program_clone.selected_components).and_return(service)
        allow(service).to receive(:clone_from_sample)
      end

      it "updates status to completed" do
        expect {
          described_class.new.perform(program_clone.id)
        }.to change { program_clone.reload.status }.from("pending").to("completed")
      end

      it "calls clone_from_sample on service" do
        described_class.new.perform(program_clone.id)
        expect(service).to have_received(:clone_from_sample)
      end

      it "sets completed_at timestamp" do
        described_class.new.perform(program_clone.id)
        expect(program_clone.reload.completed_at).to be_present
      end
    end

    context "when cloning from program" do
      let(:source_program) { create(:program) }
      let(:program_clone) { create(:program_clone, :from_program, source_program: source_program, target_program: target_program, user: user, status: "pending") }
      let(:service) { instance_double(WizardProgramService) }

      before do
        allow(WizardProgramService).to receive(:new).with(target_program.id, program_clone.selected_components).and_return(service)
        allow(service).to receive(:clone_from_program)
      end

      it "calls clone_from_program on service with source program" do
        described_class.new.perform(program_clone.id)
        expect(service).to have_received(:clone_from_program).with(source_program)
      end

      it "updates status to completed" do
        expect {
          described_class.new.perform(program_clone.id)
        }.to change { program_clone.reload.status }.from("pending").to("completed")
      end
    end

    context "when an error occurs" do
      let(:program_clone) { create(:program_clone, target_program: target_program, user: user, status: "pending") }
      let(:service) { instance_double(WizardProgramService) }
      let(:error_message) { "Something went wrong" }

      before do
        allow(WizardProgramService).to receive(:new).with(target_program.id, program_clone.selected_components).and_return(service)
        allow(service).to receive(:clone_from_sample).and_raise(StandardError.new(error_message))
      end

      it "updates status to failed" do
        expect {
          described_class.new.perform(program_clone.id) rescue nil
        }.to change { program_clone.reload.status }.from("pending").to("failed")
      end

      it "stores error message" do
        described_class.new.perform(program_clone.id) rescue nil
        expect(program_clone.reload.error_message).to eq(error_message)
      end

      it "re-raises the error" do
        expect {
          described_class.new.perform(program_clone.id)
        }.to raise_error(StandardError, error_message)
      end
    end

    context "when program_clone does not exist" do
      it "does not raise an error" do
        expect {
          described_class.new.perform(999999)
        }.not_to raise_error
      end
    end
  end
end
