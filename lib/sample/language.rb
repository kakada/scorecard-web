# frozen_string_literal: true

module Sample
  class Language
    def self.load
      languages = [
        { code: "cn", name: "Chinese" },
        { code: "vn", name: "Vietname" },
      ]

      languages.each do |lang|
        language = ::Language.create(lang)
        assign_json_file(language)
      end
    end

    private_class_method
    def self.assign_json_file(language)
      json_file = json_files.select { |image| image.split("/").last.split(".").first == language[:code] }.first
      return if json_file.nil? || !File.exist?(json_file)

      language.json_file = Pathname.new(json_file).open
      language.save
    end

    def self.json_files
      @json_files ||= Dir.glob(Rails.root.join("lib", "sample", "assets", "languages", "*"))
    end
  end
end
