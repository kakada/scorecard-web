# frozen_string_literal: true

module Api
  module Exceptions
    class ParameterMissingError < Error
      attr_reader :param

      def initialize(param)
        @param = param
        @status = 400
      end

      def errors
        [
          Api::Error.new(
            code: status,
            status: :bad_request,
            title: "Missing Parameter Error",
            detail: "The required parameter, #{param}, is missing."
          )
        ]
      end
    end
  end
end
