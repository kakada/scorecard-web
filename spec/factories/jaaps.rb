# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id          :uuid             not null, primary key
#  province_id :string
#  district_id :string
#  commune_id  :string
#  reference   :string
#  data        :jsonb
#  program_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :jaap do
    province_id { "01" }
    district_id  { "0102" }
    commune_id   { "010201" }
    data         { {} }
    program

    trait :with_data do
      data do
        [
          {
            "no" => "1",
            "priority_activity" => "Test Activity",
            "proposer" => "Test Proposer",
            "target_response" => "Response",
            "location" => "Test Location",
            "result_quantity" => 100,
            "result_unit" => "unit",
            "start_date" => "Jan 2023",
            "end_date" => "Dec 2023",
            "beneficiary_total" => 1000,
            "beneficiary_female" => 500,
            "estimated_cost" => 10000,
            "implementer" => "Test Implementer"
          }
        ].to_json
      end
    end
  end
end
