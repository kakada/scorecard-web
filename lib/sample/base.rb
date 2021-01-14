# frozen_string_literal: true

module Sample
  class Base
    def self.write_to_file(data, filename)
      Dir.mkdir('public/db') unless File.exist?('public/db')
      file_path = Rails.root.join('public', 'db', "#{filename}.json")
      content = JSON.pretty_generate(data)

      File.open(file_path, 'w') do |f|
        f.puts(content)
      end
    end
  end
end
