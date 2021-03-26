# frozen_string_literal: true

module Scorecards::TemplateField
  extend ActiveSupport::Concern

  included do
    def self.template_fields
      [
        { code: "scorecard_province", name: "province" },
        { code: "scorecard_district", name: "district" },
        { code: "scorecard_commune", name: "commune" },
        { code: "v_result_table", name: "result_table" },
      ]
    end
  end
end
