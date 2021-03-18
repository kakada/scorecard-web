# frozen_string_literal: true

module V1
  module Exceptions
    class InvalidTypeError < Error
      def initialize
        @status = 409
      end

      def errors
        [
          V1::Error.new(
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
