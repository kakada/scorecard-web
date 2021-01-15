# frozen_string_literal: true

require "ndjson"

class Exporters::NdjsonExporter < Exporters::BaseExporter
  def export(filename)
    generator = NDJSON::Generator.new(get_file_path("#{filename}_ndjson"))

    datasource.find_each do |item|
      generator.write("#{item.class}JsonBuilder".constantize.new(item).build)
    end
  end
end
