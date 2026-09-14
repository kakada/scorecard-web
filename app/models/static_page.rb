# frozen_string_literal: true

# == Schema Information
#
# Table name: static_pages
#
#  id         :uuid             not null, primary key
#  slug       :string           not null
#  content_en :text
#  content_km :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StaticPage < ApplicationRecord
  validates :slug, presence: true, uniqueness: true

  def content_by_locale(locale = I18n.locale)
    if locale.to_s == "km"
      content_km.presence || content_en
    else
      content_en.presence || content_km
    end
  end
end
