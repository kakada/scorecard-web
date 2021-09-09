require 'sample/sample'

class ProgramService
  attr_reader :program

  def initialize(program_id)
    @program = Program.find(program_id)
  end

  def clone_from_sample
    ::ScorecardCriteria::Language.load(program.name)
    ::Sample::PdfTemplate.load(program.name)
    ::ScorecardCriteria::Facility.load(program.name)
    ::ScorecardCriteria::Indicator.load(program.name)
    ::ScorecardCriteria::RatingScale.load(program.name)
  end

  def clone_from_program(from_program)
    clone_languages(from_program)
    clone_pdf_template(from_program)
    clone_facilities(from_program)
    clone_indicators(from_program)
    clone_rating_scales(from_program)
  end

  private
    def clone_languages(from_program)
      from_program.languages.each do |language|
        new_language = program.languages.find_or_initialize_by(code: language.code)
        new_language.update(name_en: language.name_en, name_km: language.name_km)
      end
    end

    def clone_pdf_template(from_program)
      from_program.pdf_templates.each do |pdf_template|
        new_template = program.pdf_templates.find_or_initialize_by(language_code: pdf_template.language_code)
        new_template.update(name: pdf_template.name, content: pdf_template.content)
      end
    end

    def clone_facilities(from_program)
      from_program.facilities.each do |facility|
        new_facility = program.facilities.find_or_initialize_by(code: facility.code)
        new_parent_id = nil

        if parent = facility.parent.presence
          new_parent = program.facilities.find_or_initialize_by(code: parent.code)
          new_parent.update(name_en: parent.name_en, name_km: parent.name_km) if new_parent.new_record?
          new_parent_id = new_parent.id
        end

        new_facility.update(name_en: facility.name_en, name_km: facility.name_km, dataset: facility.dataset, parent_id: new_parent_id)
      end
    end

    def clone_indicators(from_program)
      from_program.facilities.each do |facility|
        new_facility = program.facilities.find_by(code: facility.code)

        facility.indicators.each do |indicator|
          new_indicator = new_facility.indicators.find_or_initialize_by(name: indicator.name)
          new_indicator.update(tag_id: indicator.tag_id, display_order: indicator.display_order)

          clone_language_indicators(indicator, new_indicator)
        end
      end
    end

    def clone_language_indicators(indicator, new_indicator)
      indicator.languages_indicators.each do |lang_indi|
        language = program.languages.find_by(code: lang_indi.language_code)

        new_lang_indi = new_indicator.languages_indicators.find_or_initialize_by(language_code: lang_indi.language_code)
        new_lang_indi.update(language_id: language.id, content: lang_indi.content, audio: lang_indi.audio, version: lang_indi.version)
      end
    end

    def clone_rating_scales(from_program)
      from_program.rating_scales.each do |rating_scale|
        new_rating_scale = program.rating_scales.find_or_initialize_by(code: rating_scale.code)
        new_rating_scale.update(name: rating_scale.name, value: rating_scale.value)

        clone_languages_rating_scales(rating_scale, new_rating_scale)
      end
    end

    def clone_languages_rating_scales(rating_scale, new_rating_scale)
      rating_scale.language_rating_scales.each do |language_rating_scale|
        language = program.languages.find_by(code: language_rating_scale.language_code)

        new_language_rating_scale = new_rating_scale.language_rating_scales.find_or_initialize_by(language_code: language_rating_scale.language_code)
        new_language_rating_scale.update(language_id: language.id, audio: language_rating_scale.audio, content: language_rating_scale.content)
      end
    end
end
