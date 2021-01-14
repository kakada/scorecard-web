# frozen_string_literal: true

module Sample
  class Base
    def self.write_to_file(data, filename)
      content = JSON.pretty_generate(data)

      File.open(get_file_path(filename), "w") do |f|
        f.puts(content)
      end
    end

    def self.get_file_path(filename)
      Dir.mkdir("public/db") unless File.exist?("public/db")
      Rails.root.join("public", "db", "#{filename}.json").to_s
    end
  end
end
