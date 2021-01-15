# frozen_string_literal: true

class Exporters::JsonExporter < Exporters::BaseExporter
  def export(filename)
    data = []
    datasource.find_each do |item|
      data << "#{item.class}JsonBuilder".constantize.new(item).build
    end

    write_to_file(data, filename)
  end

  private
    def write_to_file(data, filename)
      content = JSON.pretty_generate(data)

      File.open(get_file_path(filename), "w") do |f|
        f.puts(content)
      end
    end
end
