# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_issues
#
#  id               :bigint           not null, primary key
#  scorecard_uuid   :string
#  raised_person_id :integer
#  content          :text
#  audio            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :raised_issue do
  end
end
