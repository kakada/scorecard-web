# frozen_string_literal: true

# == Schema Information
#
# Table name: request_changes
#
#  id                  :uuid             not null, primary key
#  scorecard_uuid      :string
#  proposer_id         :integer
#  reviewer_id         :integer
#  year                :string
#  scorecard_type      :integer
#  province_id         :string
#  district_id         :string
#  commune_id          :string
#  primary_school_code :string
#  changed_reason      :text
#  rejected_reason     :text
#  status              :integer
#  resolved_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :request_change do
    changed_reason { FFaker::BaconIpsum.sentence }
    scorecard
    proposer { create(:user) }
  end
end
