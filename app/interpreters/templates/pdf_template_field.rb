# frozen_string_literal: true

module Templates
  class PdfTemplateField
    def self.all
      [
        { name: "province", code: "scorecard.province", tooltip: "pdf_template.tooltip.province" },
        { name: "district", code: "scorecard.district", tooltip: "pdf_template.tooltip.district" },
        { name: "commune", code: "scorecard.commune", tooltip: "pdf_template.tooltip.commune" },
        { name: "scorecard_type", code: "scorecard.scorecard_type", tooltip: "pdf_template.tooltip.scorecard_type" },
        { name: "result_table", code: "swot.result_table", tooltip: "pdf_template.tooltip.result_table" },
        { name: "facility", code: "scorecard.facility_name", tooltip: "pdf_template.tooltip.facility" },
        { name: "facilitators", code: "scorecard.facilitators", tooltip: "pdf_template.tooltip.facilitators" },
        { name: "local_ngo", code: "scorecard.local_ngo_name", tooltip: "pdf_template.tooltip.local_ngo" },
        { name: "conducted_date", code: "scorecard.conducted_date", tooltip: "pdf_template.tooltip.conducted_date" },
        { name: "conducted_year_ce", code: "scorecard.conducted_year_ce", tooltip: "pdf_template.tooltip.conducted_year_ce" },
        { name: "conducted_year_be", code: "scorecard.conducted_year_be", tooltip: "pdf_template.tooltip.conducted_year_be" }
      ]
    end
  end
end
