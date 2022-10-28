# frozen_string_literal: true

# == Schema Information
#
# Table name: program_scorecard_types
#
#  id         :uuid             not null, primary key
#  code       :integer
#  name_en    :string
#  name_km    :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProgramScorecardType < ApplicationRecord
  belongs_to :program

  enum code: Scorecard.scorecard_types

  TYPES = [
    { code: "self_assessment", name_en: "Self assessment", name_km: "វាយតម្លៃខ្លួនឯង" },
    { code: "community_scorecard", name_en: "Community scorecard", name_km: "ប័ណ្ណដាក់ពិន្ទុសហគមន៍" }
  ]

  validates :code, presence: true
  validates :name_en, presence: true
  validates :name_km, presence: true

  def name
    self["name_#{I18n.locale}"]
  end
end
