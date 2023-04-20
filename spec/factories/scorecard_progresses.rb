# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_progresses
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  status         :integer
#  device_id      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  conducted_at   :datetime
#
FactoryBot.define do
  factory :scorecard_progress do
    scorecard
    user
    conducted_at { Time.now }
  end
end
