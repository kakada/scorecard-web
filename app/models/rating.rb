# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  scorecard_uuid        :string
#  score                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  uuid                  :string           default("uuid_generate_v4()"), not null, primary key
#  voting_indicator_uuid :string
#  participant_uuid      :string
#
class Rating < ApplicationRecord
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true
  belongs_to :participant, foreign_key: :participant_uuid, optional: true

  before_create :secure_uuid
end
