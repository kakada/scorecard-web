# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramService do
  describe "#clone_from_program" do
    let!(:program)  { create(:program, :allow_callback) }
    let!(:pdf_template) { create(:pdf_template, program: program) }
    let!(:facility) { create(:facility, :with_indicators, program: program) }

    let(:wvi)      { create(:program, name: 'World Vision', shortcut_name: 'WVI')}
    let(:service)  { ProgramService.new(wvi.id) }

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

    it { expect(wvi.facilities.length).to eq(1) }
    it { expect(wvi.facilities.length).to eq(program.facilities.length) }

    it { expect(wvi.facilities.first.indicators.length).to eq(1) }
    it { expect(wvi.facilities.first.indicators.length).to eq(program.facilities.first.indicators.length) }

    it { expect(wvi.rating_scales.length).to eq(5) }
    it { expect(wvi.rating_scales.length).to eq(program.rating_scales.length) }
   end
end
