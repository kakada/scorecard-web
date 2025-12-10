# frozen_string_literal: true

# == Schema Information
#
# Table name: predefined_facilities
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name_en       :string           not null
#  name_km       :string           not null
#  parent_code   :string
#  category_code :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class PredefinedFacility < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name_en, presence: true
  validates :name_km, presence: true

  scope :roots, -> { where(parent_code: nil) }
  scope :children_of, ->(parent_code) { where(parent_code: parent_code) }

  def name
    self["name_#{I18n.locale}"]
  end

  def parent
    return nil if parent_code.blank?
    self.class.find_by(code: parent_code)
  end

  def children
    self.class.where(parent_code: code)
  end

  def root?
    parent_code.blank?
  end
end
