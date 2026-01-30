# frozen_string_literal: true

# == Schema Information
#
# Table name: unlock_requests
#
#  id              :uuid             not null, primary key
#  scorecard_id    :integer
#  proposer_id     :integer
#  reviewer_id     :integer
#  reason          :text
#  rejected_reason :text
#  status          :integer
#  resolved_date   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :unlock_request do
    reason { FFaker::BaconIpsum.sentence }
    scorecard
    proposer { create(:user) }
  end
end
