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
#  display_order  :integer          default(0)
#  program_id     :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class IndicatorActivityCategory < ApplicationRecord
  # Associations
  belongs_to :program
  has_many :indicator_activities, dependent: :nullify

  # Validations
  validates :name_en, :name_km, presence: true

  # Callback
  before_create :set_display_order

  def name
    self["name_#{I18n.locale}"] || name_en
  end

  def description
    self["description_#{I18n.locale}"] || description_en
  end

  private
    def set_display_order
      self.display_order ||= program.indicator_activity_categories.maximum(:display_order).to_i + 1
    end
end
