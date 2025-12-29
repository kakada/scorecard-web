# frozen_string_literal: true

require "rails_helper"

RSpec.describe WizardProgramService do
  describe "#clone_from_program" do
    let!(:source_program)  { create(:program, :allow_callback) }
    let!(:pdf_template) { create(:pdf_template, program: source_program) }
    let!(:unit) { create(:facility, program: source_program) }
    let!(:facility) { create(:facility, :with_indicators, program_id: source_program.id, parent_id: unit.id) }

    let(:target_program)   { create(:program, name: "Target Program", shortcut_name: "TARGET") }
    let(:target_last_facility) { target_program.facilities.where.not(parent_id: nil).last }

    before do
      target_program.languages.delete_all
      target_program.pdf_templates.delete_all
      target_program.facilities.delete_all
      target_program.rating_scales.delete_all
    end

    context "when cloning all components" do
      let(:service) { WizardProgramService.new(target_program.id, []) }

      before do
        service.clone_from_program(source_program)
        target_program.reload
      end

      it { expect(target_program.languages.length).to eq(source_program.languages.length) }
      it { expect(target_program.pdf_templates.length).to eq(source_program.pdf_templates.length) }
      it { expect(target_program.facilities.length).to eq(source_program.facilities.length) }
      it { expect(target_last_facility.indicators.length).to eq(source_program.facilities.where.not(parent_id: nil).last.indicators.length) }
      it { expect(target_program.rating_scales.length).to eq(source_program.rating_scales.length) }
    end

    context "when cloning only languages" do
      let(:service) { WizardProgramService.new(target_program.id, ["languages"]) }

      before do
        service.clone_from_program(source_program)
        target_program.reload
      end

      it { expect(target_program.languages.length).to eq(source_program.languages.length) }
      it { expect(target_program.pdf_templates.length).to eq(0) }
      it { expect(target_program.facilities.length).to eq(0) }
      it { expect(target_program.rating_scales.length).to eq(0) }
    end

    context "when cloning only facilities and indicators" do
      let(:service) { WizardProgramService.new(target_program.id, ["facilities", "indicators"]) }

      before do
        service.clone_from_program(source_program)
        target_program.reload
      end

      it { expect(target_program.languages.length).to eq(0) }
      it { expect(target_program.facilities.length).to eq(source_program.facilities.length) }
      it { expect(target_last_facility.indicators.length).to eq(source_program.facilities.where.not(parent_id: nil).last.indicators.length) }
      it { expect(target_program.rating_scales.length).to eq(0) }
    end

    context "when cloning only rating_scales" do
      let(:service) { WizardProgramService.new(target_program.id, ["rating_scales"]) }

      before do
        service.clone_from_program(source_program)
        target_program.reload
      end

      it { expect(target_program.languages.length).to eq(0) }
      it { expect(target_program.facilities.length).to eq(0) }
      it { expect(target_program.rating_scales.length).to eq(source_program.rating_scales.length) }
    end
  end

  describe "#clone_from_sample" do
    let!(:target_program) { create(:program, :allow_callback, name: "Sample Target") }

    context "when cloning all components" do
      let(:service) { WizardProgramService.new(target_program.id, []) }

      before do
        allow(::Samples::Language).to receive(:load)
        allow(::Samples::PdfTemplate).to receive(:load)
        allow(::Samples::Facility).to receive(:load)
        allow(::Samples::Indicator).to receive(:load)
        allow(::Samples::RatingScale).to receive(:load)

        service.clone_from_sample
      end

      it "invokes all Samples loaders" do
        expect(::Samples::Language).to have_received(:load).with(target_program.name)
        expect(::Samples::PdfTemplate).to have_received(:load).with(target_program.name)
        expect(::Samples::Facility).to have_received(:load).with(target_program.name)
        expect(::Samples::Indicator).to have_received(:load).with(target_program.name)
        expect(::Samples::RatingScale).to have_received(:load).with(target_program.name)
      end
    end

    context "when cloning only selected components" do
      let(:service) { WizardProgramService.new(target_program.id, ["languages", "pdf_templates"]) }

      before do
        allow(::Samples::Language).to receive(:load)
        allow(::Samples::PdfTemplate).to receive(:load)
        allow(::Samples::Facility).to receive(:load)
        allow(::Samples::Indicator).to receive(:load)
        allow(::Samples::RatingScale).to receive(:load)

        service.clone_from_sample
      end

      it "invokes only selected Samples loaders" do
        expect(::Samples::Language).to have_received(:load).with(target_program.name)
        expect(::Samples::PdfTemplate).to have_received(:load).with(target_program.name)
        expect(::Samples::Facility).not_to have_received(:load)
        expect(::Samples::Indicator).not_to have_received(:load)
        expect(::Samples::RatingScale).not_to have_received(:load)
      end
    end
  end
end
