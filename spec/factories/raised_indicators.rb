# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                 :bigint           not null, primary key
#  indicatorable_id   :integer
#  indicatorable_type :string
#  raised_person_id   :integer
#  scorecard_uuid     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :raised_indicator do
  end
end
