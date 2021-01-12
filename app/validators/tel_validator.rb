# frozen_string_literal: true

class TelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/i.match?(value)
      record.errors.add attribute, (options[:message] || "is not an phone number")
    end
  end
end
