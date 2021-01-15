# frozen_string_literal: true

module Exporters
  class BaseExporter
    attr_reader :datasource

    def initialize(datasource)
      @datasource = datasource
    end

    private
      def get_file_path(filename)
        Dir.mkdir("public/exports") unless File.exist?("public/exports")
        Rails.root.join("public", "exports", "#{filename}.json").to_s
      end
  end
end
