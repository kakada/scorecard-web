# frozen_string_literal: true

module Api
  module Exceptions
    class NoPermissionError < Error
      def initialize(action)
        @action = action
        @status = 403
      end

      def errors
        [
          Api::Error.new(
            code: status,
            status: :forbidden,
            title: "No Permission Error",
            detail: "You are not allowed to #{@action}"
          )
        ]
      end
    end
  end
end
