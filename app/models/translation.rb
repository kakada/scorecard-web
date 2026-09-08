# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id         :uuid             not null, primary key
#  key        :string           not null
#  locale     :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Translation < ApplicationRecord
  # This model is used specifically for Grafana dashboard translations.
  validates :key, presence: true, uniqueness: { scope: :locale }
  validates :locale, presence: true
  validates :label, presence: true

  # Translation.lookup("title1", "km") => "ចំណងជើង១"
  def self.lookup(key, locale)
    find_by(key: key, locale: locale)&.label
  end
end
