# frozen_string_literal: true

module V1
  module Exceptions
    class InternalServerError < Error
      attr_reader :exception

      def initialize(exception)
        @exception = exception
        @status    = 500
      end

      def errors
        hash = {
          code: status,
          status: :internal_server_error,
          title: "Internal Server Error",
          detail: "Internal Server Error"
        }

        unless Rails.env.production?
          hash[:meta] = {}
          hash[:meta][:exception] = exception.message
          hash[:meta][:backtrace] = exception.backtrace
        end

        [
          V1::Error.new(hash)
        ]
      end
    end
  end
end
