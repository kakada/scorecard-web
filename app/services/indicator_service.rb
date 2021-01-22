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

  private
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
