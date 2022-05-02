# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_knowledges
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_km    :string
#
class ScorecardKnowledge < ApplicationRecord
  has_many :cafs_scorecard_knowledges
  has_many :cafs, through: :cafs_scorecard_knowledges

  validates :code, presence: true
  validates :name_en, presence: true
  validates :name_km, presence: true

  def name
    self["name_#{I18n.locale}"]
  end
end
