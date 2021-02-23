# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  datetime_format :string           default("DD-MM-YYYY")
#
class Program < ApplicationRecord
  has_many :users
  has_many :languages
  has_many :facilities
  has_many :templates
  has_many :local_ngos
  has_many :scorecards
  has_many :rating_scales
  has_many :contacts

  validates :name, presence: true

  after_create :create_default_language

  DATETIME_FORMATS = {
    "YYYY-MM-DD" => "%Y-%m-%d",
    "DD-MM-YYYY" => "%d-%m-%Y"
  }

  accepts_nested_attributes_for :rating_scales, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true

  private
    def create_default_language
      languages.create(code: "km", name_en: "Khmer", name_km: "ខ្មែរ")
    end
end
