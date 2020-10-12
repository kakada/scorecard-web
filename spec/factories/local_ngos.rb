# == Schema Information
#
# Table name: local_ngos
#
#  id          :bigint           not null, primary key
#  name        :string
#  province_id :string(2)
#  district_id :string(4)
#  commune_id  :string(6)
#  village_id  :string(8)
#  address     :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :local_ngo do

  end
end
