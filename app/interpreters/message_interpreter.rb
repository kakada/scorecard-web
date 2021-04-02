# frozen_string_literal: true

class MessageInterpreter
  attr_reader :scorecard, :message

  def initialize(scorecard_id, message)
    @scorecard = ::Scorecard.find_by id: scorecard_id
    @message = message
  end

  def interpreted_message
    return message if scorecard.nil?

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
      value = "Messages::#{model.camelcase}Interpreter".constantize.new(scorecard).load(field)

      "<b>#{value}</b>"
      rescue
        Rails.logger.warn "Model #{model} and field #{field} is unknwon"
        ""
    end

    def embeded_fields
      @embeded_fields ||= message.scan(/{{([^}]*)}}/).flatten.uniq
    end
end
