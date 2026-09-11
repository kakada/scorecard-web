# frozen_string_literal: true

class StaticPage < ApplicationRecord
  acts_as_paranoid

  validates :slug, presence: true, uniqueness: true

  def content_by_locale(locale = I18n.locale)
    if locale.to_s == "km"
      content_km.presence || content_en
    else
      content_en.presence || content_km
    end
  end
end
