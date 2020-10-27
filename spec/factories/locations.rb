# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  code       :string           not null, primary key
#  name_en    :string           not null
#  name_km    :string           not null
#  kind       :string           not null
#  parent_id  :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :location do
    code { "01" }
    name_en { "Banteay Meanchey" }
    name_km { "បន្ទាយមានជ័យ" }
    kind { "province" }
    parent_id { nil }
    latitude { 13.7531914 }
    longitude { 102.989615 }
  end
end
