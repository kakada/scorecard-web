class IndicatorService
  attr_reader :category, :template

  def initialize(category_id, template_id)
    @category = Category.find_by(id: category_id)
    @template = ::Template.find_by(id: template_id)
  end

  def clone_from_template
    return if category.nil? || template.nil?

    template.indicators.each do |old_indicator|
      new_indicator = category.indicators.new(clean_attributes(old_indicator))

      old_indicator.languages_indicators.each do |lang_indi|
        new_lang_indi = new_indicator.languages_indicators.new(clean_attributes(lang_indi))
        new_lang_indi.audio = File.open(lang_indi.audio.file.file) if lang_indi.audio.present?
      end
    end

    category.save
  end

  private
    def clean_attributes(object)
      object.attributes.except(*except_attributes)
    end

    def except_attributes
      %w[id created_at updated_at audio]
    end
end
