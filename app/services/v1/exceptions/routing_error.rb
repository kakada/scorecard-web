# frozen_string_literal: true

module V1
  module Exceptions
    class RoutingError < Error
      def initialize(method, path)
        @method = method
        @path   = path
        @status = 404
      end

      def errors
        [
          V1::Error.new(
            code: status,
            status: :not_found,
            title: "Routing Error",
            detail: "No route matches [#{@method}] #{@path}."
          )
        ]
      end
    end
  end
end
