# frozen_string_literal: true

module IndicatorsHelper
  def image_information
    str = "<div class='text-left'>"
    str += "<div class='mb-1'>#{I18n.t('indicator.recommended_image')}</div>"
    str += "<div>JPEG or 32-bit PNG</div>"
    str += "<div>160 px by 160 px</div>"
    str += "<div>#{I18n.t('indicator.up_to_1mb')}</div>"
    str += "<div class='mt-1'>#{I18n.t('indicator.other_not_perfect')}</div>"
    str += "</div>"
    str
  end
end
