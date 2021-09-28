# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string
#  name_en    :string
#  json_file  :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_km    :string
#
class Language < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :languages_indicators
  has_many :indicators, through: :languages_indicators

  validates :code, presence: true
  validates :name_en, presence: true
  validates :name_km, presence: true

  def name
    self["name_#{I18n.locale}"]
  end
end
