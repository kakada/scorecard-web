# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :uuid             not null, primary key
#  code        :string
#  name_en     :string
#  name_km     :string
#  category_id :string
#  province_id :string
#  district_id :string
#  commune_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :dataset do
  end
end
