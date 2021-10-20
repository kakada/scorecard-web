# frozen_string_literal: true

class RequestLogParser
  class << self
    def parse(data)
      @data = data
      data_params.merge(payload_params)
    end

    private
      def data_params
        @data.slice(*whitelist_attribute)
      end

      def payload_params
        @data[:params].to_h.except(:action, :controller)
      end

      def whitelist_attribute
        %i[controller action format method path status current_user_id]
      end
  end
end
