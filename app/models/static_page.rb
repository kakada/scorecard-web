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
  ALLOWED_CONTENT_TAGS = %w[h1 h2 h3 h4 h5 h6 div p span strong em br img style a ul li].freeze
  ALLOWED_CONTENT_ATTRIBUTES = %w[class style src href alt].freeze

  validates :slug, presence: true, uniqueness: true

  # This method generates the event name for the static page, used for tracking views.
  def event_name
    "view_#{slug}"
  end

  def url
    "/#{slug}"
  end

  def content_by_locale(locale = I18n.locale)
    if locale.to_s == "km"
      content_km.presence || content_en
    else
      content_en.presence || content_km
    end
  end

  def rendered_content_by_locale(locale = I18n.locale)
    self.class.interpolate_content(content_by_locale(locale))
  end

  def self.interpolate_content(content)
    content = content.to_s
    keys = content.scan(/\{\{([A-Za-z0-9_]+)\}\}/).flatten.map(&:upcase).uniq
    return content if keys.blank?

    variables_by_key = StaticPageVariable.where(key: keys).index_by(&:key)

    content.gsub(/\{\{([A-Za-z0-9_]+)\}\}/) do |match|
      variable = variables_by_key[Regexp.last_match(1).upcase]
      variable.present? ? variable.rendered_value : match
    end
  end
end
