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
  validates :name_en, uniqueness: { scope: :program_id }
  validates :name_km, uniqueness: { scope: :program_id }

  # Callback
  before_create :set_display_order

  scope :ordered, -> { order(display_order: :asc, created_at: :asc) }

  def name
    self["name_#{I18n.locale}"] || name_en
  end

  def description
    self["description_#{I18n.locale}"] || description_en
  end

  def locked?
    indicator_activities.exists?
  end

  def remove!
    return if locked?

    destroy
  end

  def move_up!
    adjacent = program.indicator_activity_categories.where("display_order < ?", display_order).order(display_order: :desc).first
    swap_order_with(adjacent)
  end

  def move_down!
    adjacent = program.indicator_activity_categories.where("display_order > ?", display_order).order(display_order: :asc).first
    swap_order_with(adjacent)
  end

  private
    def set_display_order
      self.display_order ||= program.indicator_activity_categories.maximum(:display_order).to_i + 1
    end

    def swap_order_with(category)
      return unless category.present?

      self.class.transaction do
        current_order = display_order
        update!(display_order: category.display_order)
        category.update!(display_order: current_order)
      end
    end
end
