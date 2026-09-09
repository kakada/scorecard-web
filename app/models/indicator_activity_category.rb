# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_activity_categories
#
#  id             :uuid             not null, primary key
#  name_en        :string
#  name_km        :string
#  description_en :text
#  description_km :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class IndicatorActivityCategory < ApplicationRecord
  has_many :indicator_activities, dependent: :nullify

  validates :name_en, :name_km, presence: true

  def name
    self["name_#{I18n.locale}"] || name_en
  end

  def description
    self["description_#{I18n.locale}"] || description_en
  end
end
