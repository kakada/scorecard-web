# frozen_string_literal: true

require "samples/sample"

class WizardProgramService
  ALLOWED_COMPONENTS = %w[languages facilities indicators rating_scales pdf_templates].freeze

  attr_reader :target_program, :selected_components

  def initialize(target_program_id, selected_components = [])
    @target_program = Program.find(target_program_id)
    @selected_components = selected_components.map(&:to_s) & ALLOWED_COMPONENTS
  end

  # Clone selected components from sample data
  def clone_from_sample
    clone_languages_from_sample if should_clone?("languages")
    clone_pdf_templates_from_sample if should_clone?("pdf_templates")
    clone_facilities_from_sample if should_clone?("facilities")
    clone_indicators_from_sample if should_clone?("indicators")
    clone_rating_scales_from_sample if should_clone?("rating_scales")
  end

  # Clone selected components from another program
  def clone_from_program(source_program)
    clone_languages(source_program) if should_clone?("languages")
    clone_pdf_template(source_program) if should_clone?("pdf_templates")
    clone_facilities(source_program) if should_clone?("facilities")
    clone_indicators(source_program) if should_clone?("indicators")
    clone_rating_scales(source_program) if should_clone?("rating_scales")
  end

  private
    def should_clone?(component)
      selected_components.empty? || selected_components.include?(component)
    end

    # Sample cloning methods
    def clone_languages_from_sample
      ::Samples::Language.load(target_program.name)
    end

    def clone_pdf_templates_from_sample
      ::Samples::PdfTemplate.load(target_program.name)
    end

    def clone_facilities_from_sample
      ::Samples::Facility.load(target_program.name)
    end

    def clone_indicators_from_sample
      ::Samples::Indicator.load(target_program.name)
    end

    def clone_rating_scales_from_sample
      ::Samples::RatingScale.load(target_program.name)
    end

    # Program cloning methods (from ProgramService)
    def clone_languages(source_program)
      source_program.languages.each do |language|
        new_language = target_program.languages.find_or_initialize_by(code: language.code)
        new_language.update(name_en: language.name_en, name_km: language.name_km)
      end
    end

    def clone_pdf_template(source_program)
      source_program.pdf_templates.each do |pdf_template|
        new_template = target_program.pdf_templates.find_or_initialize_by(language_code: pdf_template.language_code)
        new_template.update(name: pdf_template.name, content: pdf_template.content)
      end
    end

    def clone_facilities(source_program)
      source_program.facilities.each do |facility|
        new_facility = target_program.facilities.find_or_initialize_by(code: facility.code)
        new_parent_id = nil

        if parent = facility.parent.presence
          new_parent = target_program.facilities.find_or_initialize_by(code: parent.code)
          new_parent.update(name_en: parent.name_en, name_km: parent.name_km) if new_parent.new_record?
          new_parent_id = new_parent.id
        end

        new_facility.update(name_en: facility.name_en, name_km: facility.name_km, dataset: facility.dataset, parent_id: new_parent_id, category_id: facility.category_id)
      end
    end

    def clone_indicators(source_program)
      source_program.facilities.where.not(parent_id: nil).each do |facility|
        new_facility = target_program.facilities.find_by(code: facility.code)
        next unless new_facility

        facility.indicators.each do |indicator|
          new_indicator = new_facility.indicators.find_or_initialize_by(name: indicator.name)
          new_indicator.update(tag_id: indicator.tag_id, display_order: indicator.display_order)

          clone_language_indicators(indicator, new_indicator)
        end
      end
    end

    def clone_language_indicators(indicator, new_indicator)
      indicator.languages_indicators.each do |lang_indi|
        language = target_program.languages.find_by(code: lang_indi.language_code)
        next unless language

        new_lang_indi = new_indicator.languages_indicators.find_or_initialize_by(language_code: lang_indi.language_code)
        new_lang_indi.update(language_id: language.id, content: lang_indi.content, audio: lang_indi.audio, version: lang_indi.version)
      end
    end

    def clone_rating_scales(source_program)
      source_program.rating_scales.each do |rating_scale|
        new_rating_scale = target_program.rating_scales.find_or_initialize_by(code: rating_scale.code)
        new_rating_scale.update(name: rating_scale.name, value: rating_scale.value)

        clone_languages_rating_scales(rating_scale, new_rating_scale)
      end
    end

    def clone_languages_rating_scales(rating_scale, new_rating_scale)
      rating_scale.language_rating_scales.each do |language_rating_scale|
        language = target_program.languages.find_by(code: language_rating_scale.language_code)
        next unless language

        new_language_rating_scale = new_rating_scale.language_rating_scales.find_or_initialize_by(language_code: language_rating_scale.language_code)
        new_language_rating_scale.update(language_id: language.id, audio: language_rating_scale.audio, content: language_rating_scale.content)
      end
    end
end
