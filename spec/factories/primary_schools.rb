# frozen_string_literal: true

# == Schema Information
#
# Table name: primary_schools
#
#  id          :bigint           not null, primary key
#  code        :string
#  name_en     :string
#  name_km     :string
#  commune_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  district_id :string
#  province_id :string
#
FactoryBot.define do
  factory :primary_school do
    code       { FFaker::Code.npi }
    name_en    { FFaker::Name.name }
    name_km    { FFaker::Name.name }
    commune_id { Pumi::Commune.all.sample.id }
  end
end
