# frozen_string_literal: true

module Api
  module Exceptions
    class Error < RuntimeError
      attr_reader :status

      def to_json(_options = {})
        { errors: errors }.to_json
      end
    end
  end
end
