# frozen_string_literal: true

module ExcelBuilders
  class IndicatorExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header
      build_row(@scorecards)
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.indicator_id"),
        I18n.t("excel.indicator_name"),
        I18n.t("excel.indicator_tag"),
        I18n.t("excel.is_custom_indicator"),
        I18n.t("excel.facility_name"),
      ]
    end

    def build_row(scorecards)
      uuids = scorecards.includes(:raised_indicators).map { |s| s.raised_indicators.pluck(:indicator_uuid) }.flatten.uniq

      Indicator.where(uuid: uuids).find_each do |indi|
        sheet.add_row generate_row(indi)
      end
    end

    private
      def generate_row(indicator)
        [
          indicator.uuid,
          indicator.name,
          indicator.tag_name,
          indicator.type == "Indicators::CustomIndicator",
          indicator.categorizable.try(:name)
        ]
      end
  end
end
