# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  id                  :bigint           not null, primary key
#  voting_indicator_id :integer
#  voting_person_id    :integer
#  scorecard_uuid      :string
#  score               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Rating < ApplicationRecord
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  before_create :secure_uuid
end
