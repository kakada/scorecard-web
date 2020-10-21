# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  unit_type_id          :integer
#  category_id           :integer
#  name                  :string
#  description           :text
#  province_id           :string(2)
#  district_id           :string(4)
#  commune_id            :string(6)
#  year                  :integer
#  conducted_date        :datetime
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  planned_start_date    :datetime
#  planned_end_date      :datetime
#  status                :integer
#  program_id            :integer
#  local_ngo_id          :integer
#  scorecard_type_id     :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :scorecard do
    year         { Date.today.year }
    category     { create(:category, :with_parent) }
    unit_type_id { category.parent_id }
    program
    local_ngo
    scorecard_type
    commune_id   { Pumi::Commune.all.sample.id }
    district_id  { Pumi::Commune.find_by_id(commune_id).district_id }
    province_id  { Pumi::Commune.find_by_id(commune_id).province_id }
  end
end
