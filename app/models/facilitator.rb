# == Schema Information
#
# Table name: facilitators
#
#  id             :bigint           not null, primary key
#  caf_id         :integer
#  scorecard_uuid :integer
#  position       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Facilitator < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid
  belongs_to :caf
end
