# == Schema Information
#
# Table name: indicators
#
#  id          :bigint           not null, primary key
#  category_id :integer
#  tag         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Indicator < ApplicationRecord
  belongs_to :categorizable, :polymorphic => true
  has_many :languages_indicators
  has_many :languages, through: :languages_indicators

  # Nested Attributes
  accepts_nested_attributes_for :languages_indicators, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['content'].blank? && attributes['audio'].blank?
  }
end
