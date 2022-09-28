# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  hierarchy  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :category do
    code      { "D_PS" }
    name_en   { "Primary School" }
    name_km   { "បឋមសិក្សា" }
    hierarchy { ["province", "district", "commune"] }

    trait :health_center do
      code      { "D_HC" }
      name_en   { "Health Center" }
      name_km   { "មណ្ឌលសុខភាព" }
      hierarchy { ["province", "district"] }
    end
  end
end
