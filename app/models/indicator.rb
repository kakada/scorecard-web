# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  tag_id             :integer
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Indicator < ApplicationRecord
  include Indicatorable
  include Tagable

  belongs_to :categorizable, polymorphic: true
  has_many :languages_indicators
  has_many :languages, through: :languages_indicators

  validates :name, presence: true, uniqueness: { scope: [:categorizable_id, :categorizable_type] }

  # Nested Attributes
  accepts_nested_attributes_for :languages_indicators, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["content"].blank? && attributes["audio"].blank?
  }
end
