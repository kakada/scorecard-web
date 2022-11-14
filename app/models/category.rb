# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  hierarchy  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  serialize :hierarchy, Array

  has_many :datasets, dependent: :destroy
  has_many :facilities

  validates :code, presence: true, uniqueness: true
  validates :name_en, presence: true, uniqueness: true
  validates :name_km, presence: true, uniqueness: true
  validates :hierarchy, presence: true

  before_validation :clean_hierarchy

  def name
    self["name_#{I18n.locale}"]
  end

  def column_code_name
    @column_code_name ||= name_en.downcase.split(" ").join("_") + "_code"
  end

  def hierarchy_display
    return "" unless hierarchy.present?

    hierarchy.map do |step|
      I18n.t("category.#{step}")
    end.push(name).join(" → ")
  end

  def clean_hierarchy
    self.hierarchy = hierarchy.reject(&:blank?)
  end
end
