# frozen_string_literal: true

module Api
  module Exceptions
    class NotSupportedError < Error
      attr_reader :name

      def initialize(name)
        @name = name
        @status = 426
      end

      def errors
        [
          Api::Error.new(
            code: status,
            status: :upgrade_required,
            title: "Not Supported",
            detail: "#{name} is not supported."
          )
        ]
      end
    end
  end
end
