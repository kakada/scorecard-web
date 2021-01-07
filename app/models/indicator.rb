# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#
class Indicator < ApplicationRecord
  include Indicatorable
  include Tagable

  belongs_to :categorizable, polymorphic: true, touch: true
  has_many :languages_indicators
  has_many :languages, through: :languages_indicators

  validates :name, presence: true, uniqueness: { scope: [:categorizable_id, :categorizable_type] }

  before_create :set_display_order

  default_scope { order(display_order: :asc) }

  # Nested Attributes
  accepts_nested_attributes_for :languages_indicators, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["audio"] = nil if attributes["remove_audio"] == "1"
    return attributes["id"].blank? && attributes["content"].blank? && attributes["audio"].blank?
  }

  def editable_tag?
    raised_indicators.blank?
  end

  private
    def set_display_order
      self.display_order ||= categorizable.present? && categorizable.indicators.maximum(:display_order).to_i + 1
    end
end
