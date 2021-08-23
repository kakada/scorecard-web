# frozen_string_literal: true

class PdfTemplateSampleInterpreter
  attr_reader :scorecard, :message, :pdf_template

  def initialize(pdf_template_id)
    @pdf_template = ::PdfTemplate.find_by id: pdf_template_id
    @message = @pdf_template.try(:content)
  end

  def interpreted_message
    return "" if pdf_template.nil? || message.blank?

    sms = message
    embeded_fields.each do |embeded_field|
      sms = sms.gsub(/#{"{{" + embeded_field + "}}"}/, get_field_value(embeded_field).to_s)
    end
    sms
  end

  private
    def get_field_value(embeded_field)
      model = embeded_field.split(".")[0]
      field = embeded_field.split(".")[1]

      "PdfTemplates::#{model.camelcase}SampleInterpreter".constantize.new.load(field)
      rescue
        Rails.logger.warn "Model #{model} and field #{field} is unknwon"
        ""
    end

    def embeded_fields
      @embeded_fields ||= message.scan(/{{([^}]*)}}/).flatten.uniq
    end
end
