# frozen_string_literal: true

module Api
  module Exceptions
    class RecordNotFoundError < Error
      def initialize(message, params)
        @message = message
        @params = params
        @status = 404
      end

      def errors
        [
          Api::Error.new(
            code: 404,
            status: :not_found,
            title: "Record Not Found",
            detail: "The record identified by #{id} could not be found."
          )
        ]
      end

      private
        def id
          @message.match(/=(\S+)/)[1]
        end
    end
  end
end
