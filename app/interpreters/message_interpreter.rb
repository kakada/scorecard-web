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
    codes.each do |code|
      sms = sms.gsub(/#{"{{" + code + "}}"}/, get_field_value(code).to_s)
    end
    sms
  end

  private
    def get_field_value(code)
      model = code.split(".")[0]
      field = code.split(".")[1]
      value = "Messages::#{model.camelcase}Interpreter".constantize.new(scorecard).load(field)

      "<b>#{value}</b>"
      rescue
        Rails.logger.warn "Model #{model} and field #{field} is unknwon"
        ""
    end

    def codes
      @codes ||= message.scan(/{{([^}]*)}}/).flatten.uniq
    end
end
