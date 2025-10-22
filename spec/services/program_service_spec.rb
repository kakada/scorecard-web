# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramService do
  describe "#clone_from_program" do
    let!(:program)  { create(:program, :allow_callback) }
    let!(:pdf_template) { create(:pdf_template, program: program) }
    let!(:facility) { create(:facility, :with_parent, :with_indicators, program: program) }

    let(:wvi)      { create(:program, name: "World Vision", shortcut_name: "WVI") }
    let(:service)  { ProgramService.new(wvi.id) }
    let(:wvi_last_facility) { wvi.facilities.where.not(parent_id: nil).last }

    before {
      wvi.languages.delete_all
      wvi.pdf_templates.delete_all
      wvi.facilities.delete_all
      wvi.rating_scales.delete_all

      service.clone_from_program(program)
      wvi.reload
    }

    it { expect(wvi.languages.length).to eq(1) }
    it { expect(wvi.languages.length).to eq(program.languages.length) }

    it { expect(wvi.pdf_templates.length).to eq(1) }
    it { expect(wvi.pdf_templates.length).to eq(program.pdf_templates.length) }

    it { expect(wvi.facilities.length).to eq(2) }
    it { expect(wvi.facilities.length).to eq(program.facilities.length) }

    it { expect(wvi_last_facility.indicators.length).to eq(1) }
    it { expect(wvi_last_facility.indicators.length).to eq(program.facilities.where.not(parent_id: nil).last.indicators.length) }

    it { expect(wvi.rating_scales.length).to eq(5) }
    it { expect(wvi.rating_scales.length).to eq(program.rating_scales.length) }
  end

  describe "#clone_from_sample" do
    let!(:program) { create(:program, :allow_callback, name: "Sample Program") }
    let(:service) { ProgramService.new(program.id) }

    before do
      # stub out the Samples loaders so we only verify they are called with program name
      allow(::Samples::Language).to receive(:load)
      allow(::Samples::PdfTemplate).to receive(:load)
      allow(::Samples::Facility).to receive(:load)
      allow(::Samples::Indicator).to receive(:load)
      allow(::Samples::RatingScale).to receive(:load)

      service.clone_from_sample
    end

    it "invokes Samples loaders with program name" do
      expect(::Samples::Language).to have_received(:load).with(program.name)
      expect(::Samples::PdfTemplate).to have_received(:load).with(program.name)
      expect(::Samples::Facility).to have_received(:load).with(program.name)
      expect(::Samples::Indicator).to have_received(:load).with(program.name)
      expect(::Samples::RatingScale).to have_received(:load).with(program.name)
    end
  end
end
