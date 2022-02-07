# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfTemplateInterpreter do
  describe "#pdf_template" do
    let!(:pdf_template_km) { create(:pdf_template) }
    let!(:program) { pdf_template_km.program }
    let!(:scorecard) { create(:scorecard, program: program) }
    let(:interpretor) { PdfTemplateInterpreter.new(scorecard.uuid) }

    context "program pdf_template en exist" do
      let!(:pdf_template_en) { create(:pdf_template, language_code: "en", program: program) }

      before { allow(I18n).to receive(:locale).and_return(:en) }

      it { expect(interpretor.pdf_template.id).to eq(pdf_template_en.id) }
    end

    context "program pdf_template en doesn't exist" do
      before { allow(I18n).to receive(:locale).and_return(:en) }

      it { expect(interpretor.pdf_template.id).to eq(pdf_template_km.id) }
    end
  end

  describe "#message" do
    let!(:program) { create(:program) }
    let!(:scorecard) { create(:scorecard, program: program) }
    let(:interpretor) { PdfTemplateInterpreter.new(scorecard.uuid) }

    context "no program pdf_template" do
      it { expect(interpretor.pdf_template).to eq(nil) }
      it { expect(interpretor.interpreted_message).to eq("") }
    end

    context "template code 'swot.result_table' exist" do
      let!(:pdf_template_km) { create(:pdf_template, content: "<div>{{swot.result_table}}</div>", program: program) }
      let!(:voting_indicator) { create(:voting_indicator, scorecard: scorecard, median: 1) }
      let!(:strength_indicator_activity) { create(:strength_indicator_activity, voting_indicator: voting_indicator, scorecard: voting_indicator.scorecard) }
      let!(:weakness_indicator_activity) { create(:weakness_indicator_activity, voting_indicator: voting_indicator, scorecard: voting_indicator.scorecard) }
      let!(:suggested_indicator_activity) { create(:suggested_indicator_activity, voting_indicator: voting_indicator, scorecard: voting_indicator.scorecard, selected: true) }
      let(:t_head) {
        str = %w(indicator average_score strength weakness suggested_action).map { |col|
          "<th class='text-center'>" + I18n.t("scorecard.#{col}") + "</th>"
        }.join("")

        "<tr>#{str}</tr>"
      }

      let(:t_body) {
        str = "<tr>"
        str += "<td>#{voting_indicator.indicator.name}</td>"
        str += "<td class='text-center'>មិនពេញចិត្តខ្លាំង (1)</td>"
        str += "<td><ul><li>#{strength_indicator_activity.content} </li></ul></td>"
        str += "<td><ul><li>#{weakness_indicator_activity.content} </li></ul></td>"
        str += "<td><ul><li>#{suggested_indicator_activity.content} (#{I18n.t('indicator.selected')})</li></ul></td>"
        str + "</tr>"
      }

      let(:html) {
        str = "<div><table class='table table-bordered'>"
        str += "<thead>#{t_head}</thead>"
        str += "<tbody>#{t_body}</tbody>"
        str + "</table></div>"
      }

      before { I18n.locale = :km }
      it { expect(interpretor.interpreted_message).to eq(html) }
    end
  end
end
