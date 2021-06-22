# frozen_string_literal: true

# == Schema Information
#
# Table name: suggested_actions
#
#  id                    :bigint           not null, primary key
#  voting_indicator_uuid :string
#  content               :string
#  selected              :boolean
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class SuggestedAction < ApplicationRecord
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  scope :selecteds, -> { where(selected: true) }
end
