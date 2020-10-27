# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  datetime_format :string           default("YYYY-MM-DD")
#
class Program < ApplicationRecord
  has_many :users
  has_many :languages
  has_many :categories
  has_many :templates
  has_many :local_ngos
  has_many :scorecards
  has_many :scorecard_types
  has_many :local_ngos

  validates :name, presence: true

  after_create :create_default_language

  DATETIME_FORMATS = {
    "YYYY-MM-DD" => "%Y-%m-%d",
    "DD-MM-YYYY" => "%d-%m-%Y"
  }

  private
    def create_default_language
      languages.create(code: "km", name: "Khmer")
    end
end
