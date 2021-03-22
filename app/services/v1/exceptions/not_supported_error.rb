# frozen_string_literal: true

module V1
  module Exceptions
    class NotSupportedError < Error
      attr_reader :name

      def initialize(name)
        @name = name
        @status = 426
      end

      def errors
        [
          V1::Error.new(
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
