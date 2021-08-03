# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  scorecard_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tag_id         :integer
#  uuid           :string
#
FactoryBot.define do
  factory :custom_indicator do
    name { FFaker::Name.name }
    scorecard
  end
end
