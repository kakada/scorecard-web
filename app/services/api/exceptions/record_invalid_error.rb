# frozen_string_literal: true

module Api
  module Exceptions
    class RecordInvalidError < Error
      def initialize(record)
        @record = record
        @status = 422
      end

      def errors
        return @errors if @errors

        @errors = []
        @record.errors.each do |attr_key, message|
          @errors << json_api_error(attr_key, message)
        end

        @errors
      end

      private
        def json_api_error(attr_key, message)
          Api::Error.new(
            code: status,
            status: :unprocessable_entity,
            title: message,
            detail: "#{attr_key} - #{message}",
            source: { pointer: pointer(attr_key) }
          )
        end

        def pointer(attr_key)
          "/data/attributes/#{attr_key}"
        end
    end
  end
end
