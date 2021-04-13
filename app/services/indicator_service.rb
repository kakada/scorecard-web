# frozen_string_literal: true

class IndicatorService
  attr_reader :facility

  def initialize(facility_id)
    @facility = Facility.find_by(id: facility_id)
  end

  def clone_from_template(template_id)
    return unless template_id.present?

    template = ::Template.find_by(id: template_id)
    clone_indicator(template, facility)
  end

  def clone_to_template(template_name)
    return unless template_name.present?

    template = facility.program.templates.new(name: template_name)
    clone_indicator(facility, template)
  end

  def import(param_zip_file)
    Zip::File.open(param_zip_file) do |zipfile|
      @zipfile = zipfile

      upsert_indicators if facility.present?
    end
  end

  private
    def upsert_indicators
      entry = @zipfile.select { |ent| ent.name == "indicators/indicators.csv" }[0]
      rows = CSV.parse(entry.get_input_stream.read, headers: true)
      rows.each do |row|
        indicator_name = row["Scorecard Criterias"]
        next unless indicator_name.present?

        indicator = facility.indicators.find_or_initialize_by(name: indicator_name)
        indicator.update(indicator_params(row))

        upsert_languages_indicators(indicator, row)
      end
    end

    def indicator_params(row)
      { tag_attributes: { name: (row["tag"] || row["Scorecard Criterias"]) } }
    end

    def upsert_languages_indicators(indicator, row)
      facility.program.languages.each do |language|
        audio = get_audio(language, row)

        next unless audio.present?

        lang_indi = indicator.languages_indicators.find_or_initialize_by(language_code: language.code)
        lang_indi.update(
          language_id: language.id,
          language_code: language.code,
          content: "#{indicator.name} (#{language.code})",
          audio: Pathname.new(audio).open
        )
      end
    end

    def get_audio(language, row)
      column = "#{language.name_en} (#{language.code})" # Khmer (km)
      extract_file(row[column])
    end

    def extract_file(filename)
      return unless filename.present?

      file = @zipfile.select { |entry| entry.name.split("/").last.split(".").first == "#{filename.split('.').first}" }.first
      return unless file.present?

      file_destination = File.join("public/uploads/tmp", file.name)
      FileUtils.mkdir_p(File.dirname(file_destination))
      @zipfile.extract(file, file_destination) { true }

      file_destination
    end

    def clone_indicator(from_obj, to_obj)
      from_obj.indicators.each do |old_indicator|
        new_indicator = to_obj.indicators.new(clean_attributes(old_indicator))
        new_indicator.image = File.open(old_indicator.image.file.file) if old_indicator.image.present?

        old_indicator.languages_indicators.each do |lang_indi|
          new_lang_indi = new_indicator.languages_indicators.new(clean_attributes(lang_indi))
          new_lang_indi.audio = File.open(lang_indi.audio.file.file) if lang_indi.audio.present?
        end
      end

      to_obj.save
    end

    def clean_attributes(object)
      object.attributes.except(*except_attributes)
    end

    def except_attributes
      %w[id created_at updated_at audio]
    end
end
