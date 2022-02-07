# frozen_string_literal: true

# == Schema Information
#
# Table name: voting_indicators
#
#  indicatorable_id   :integer
#  indicatorable_type :string
#  scorecard_uuid     :string
#  median             :integer
#  strength           :text
#  weakness           :text
#  suggested_action   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  uuid               :string           default("uuid_generate_v4()"), not null, primary key
#  display_order      :integer
#  indicator_uuid     :string
#
FactoryBot.define do
  factory :voting_indicator do
    indicator      { create(:indicator) }
    indicatorable  { indicator }
    scorecard
    median         { rand(1..5) }
  end
end
