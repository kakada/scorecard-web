# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class DatasetInfo
    attr_accessor :workbook, :program

    def initialize(workbook, program)
      @workbook = workbook
      @program = program
    end

    def build
      program.dataset_categories.each do |category|
        ::DatasetExcelSampleExporter.new(workbook, category.datasets, category).build
      end
    end
  end
end
