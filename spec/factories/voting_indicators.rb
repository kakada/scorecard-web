# frozen_string_literal: true

# == Schema Information
#
# Table name: voting_indicators
#
#  id                 :bigint           not null, primary key
#  indicatorable_id   :integer
#  indicatorable_type :string
#  scorecard_uuid     :string
#  median             :integer
#  strength           :text
#  weakness           :text
#  desired_change     :text
#  suggested_action   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :voting_indicator do
  end
end
