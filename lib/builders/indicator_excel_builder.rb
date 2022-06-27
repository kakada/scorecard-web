# frozen_string_literal: true

class IndicatorExcelBuilder
  def initialize(workbook, indicators)
    @workbook = workbook
    @indicators = indicators
  end

  def build
    sheets = %w(suggested_action weakness strength)
    sheets.each do |sheet_name|
      build_sheet(sheet_name)
    end
  end

  private
    def build_sheet(sheet_name)
      @workbook.add_worksheet(name: sheet_name) do |sheet|
        build_header(sheet)

        @indicators.each_with_index do |indicator, index|
          build_row(sheet, indicator, index + 1)
        end
      end
    end

    def build_header(sheet)
      sheet.add_row %w(no standard_code action_name indicator_id indicator_name)
    end

    def build_row(sheet, indicator, num)
      actions = indicator.indicator_actions.predefineds.send(sheet.name)
      sheet.add_row([num, actions[0].try(:code), actions[0].try(:name), indicator.uuid, indicator.name])

      actions.drop(1).each do |action|
        sheet.add_row([ nil, action.code, action.name, indicator.uuid, nil ])
      end
    end
end
