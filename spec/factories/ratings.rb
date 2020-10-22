# == Schema Information
#
# Table name: ratings
#
#  id                  :bigint           not null, primary key
#  voting_indicator_id :integer
#  voting_person_id    :integer
#  scorecard_uuid      :string
#  score               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :rating do
    
  end
end
