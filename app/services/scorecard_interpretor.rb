# frozen_string_literal: true

class ScorecardInterpretor
  attr_reader :pdf_template

  def initialize(scorecard)
    @scorecard = scorecard
    @pdf_template = @scorecard.program.pdf_templates.find_by(language_code: I18n.locale) || @scorecard.program.pdf_templates.first
  end

  def message
    return unless pdf_template.present?

    @message = pdf_template.content
    process_message_with_scorecard
    process_message_with_result_table
    @message
  end

  private
    def process_message_with_result_table
      field = "v_result_table"
      template_code = "v_"
      indicator_fields = select_elements_starting_with(fields, template_code)

      return unless indicator_fields.include? field

      field_template = "{{#{field}}}"
      @message = @message.gsub(/#{field_template}/, build_result_table)
    end

    def process_message_with_scorecard
      template_code = "scorecard_"
      scorecard_fields = select_elements_starting_with(fields, template_code)
      scorecard_fields.each do |field|
        field_name  = field.split(template_code)[1]
        field_value = @scorecard.send(field_name)
        field_value = I18n.l(field_value) if field_value.kind_of?(ActiveSupport::TimeWithZone)
        field_template = "{{#{field}}}"

        @message = @message.gsub(/#{field_template}/, field_value)
      end
    end

    def build_result_table
      html = "<table class='table table-bordered'>"
      html += "<thead>#{ build_result_header }</thead>"
      html += "<tbody>#{ build_result_rows }</tbody>"
      html + "</table>"
    end

    def build_result_header
      columns = %w(criteria average_score strength weakness suggested_action)

      headers = columns.map { |col|
        "<th class='text-center'>" + I18n.t("scorecard.#{col}") + "</th>"
      }.join("")

      "<tr>#{headers}</tr>"
    end

    def build_result_rows
      voting_criterias = Scorecards::VotingCriteria.new(@scorecard).criterias
      voting_criterias.map { |indicator|
        "<tr>#{ build_result_columns(indicator) }</tr>"
      }.join("")
    end

    def build_result_columns(indicator)
      columns = %w(name median strength weakness suggested_action)
      columns.map do |field|
        field_value = indicator[field]

        next build_column_median(field_value) if field == "median"

        value = field_value.kind_of?(Array) ? build_list(field_value) : field_value.to_s
        "<td>#{value}</td>"
      end.join("")
    end

    def build_column_median(median)
      str = I18n.t("rating_scale.#{median}") + " (#{VotingIndicator.medians[median]})"
      "<td class='text-center'>#{str}</td>"
    end

    def build_list(list)
      "<ul>" + list.map { |value| "<li>#{value}</li>" }.join("") + "</ul>"
    end

    def fields
      @fields ||= pdf_template.content.scan(/{{([^}]*)}}/).flatten
    end

    def select_elements_starting_with(arr, letter)
      arr.select { |str| str.start_with?(letter) }
    end
end
