# frozen_string_literal: true

module Api
  module Exceptions
    class InvalidTypeError < Error
      def initialize
        @status = 409
      end

      def errors
        [
          Api::Error.new(
            code: status,
            status: :conflict,
            title: "Invalid Type Error",
            detail: "Type is missing or not match with endpoint."
          )
        ]
      end
    end
  end
end
