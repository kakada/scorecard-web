class Indicator < ApplicationRecord
  belongs_to :sector, class_name: 'Category'
  belongs_to :category
  has_many :languages_indicators
  has_many :languages, through: :languages_indicators

  # Nested Attributes
  accepts_nested_attributes_for :languages_indicators, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['content'].blank? && attributes['audio'].blank?
  }
end
