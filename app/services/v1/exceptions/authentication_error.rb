# frozen_string_literal: true

module V1
  module Exceptions
    class AuthenticationError < Error
      def initialize
        @status = 401
      end

      def errors
        [
          V1::Error.new(
            code: status,
            status: :unauthorized,
            title: "Authentication Error",
            detail: "Authentication is required."
          )
        ]
      end
    end
  end
end
