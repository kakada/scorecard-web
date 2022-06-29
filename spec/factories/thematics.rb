# == Schema Information
#
# Table name: thematics
#
#  id          :uuid             not null, primary key
#  code        :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :thematic do
    name   { FFaker::Name.name }
    description { FFaker::BaconIpsum.sentence }
  end
end
