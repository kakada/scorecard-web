# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class Base
    attr_accessor :sheet, :program

    def initialize(sheet, program)
      @sheet = sheet
      @program = program
    end

    def build
      build_headers
      build_rows
    end

    private
      def build_headers
        raise "Implement it in sub class"
      end

      def build_rows
        raise "Implement it in sub class"
      end
  end
end
