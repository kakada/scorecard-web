# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards_cafs
#
#  id           :bigint           not null, primary key
#  caf_id       :integer
#  scorecard_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :scorecards_caf do
  end
end
