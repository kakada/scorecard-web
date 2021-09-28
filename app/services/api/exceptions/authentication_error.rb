# frozen_string_literal: true

module Api
  module Exceptions
    class AuthenticationError < Error
      def initialize
        @status = 401
      end

      def errors
        [
          Api::Error.new(
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
