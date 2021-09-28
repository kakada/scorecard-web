# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                        :bigint           not null, primary key
#  uuid                      :string
#  unit_type_id              :integer
#  facility_id               :integer
#  name                      :string
#  description               :text
#  province_id               :string(2)
#  district_id               :string(4)
#  commune_id                :string(6)
#  year                      :integer
#  conducted_date            :datetime
#  number_of_caf             :integer
#  number_of_participant     :integer
#  number_of_female          :integer
#  planned_start_date        :datetime
#  planned_end_date          :datetime
#  status                    :integer
#  program_id                :integer
#  local_ngo_id              :integer
#  scorecard_type            :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  location_code             :string
#  number_of_disability      :integer
#  number_of_ethnic_minority :integer
#  number_of_youth           :integer
#  number_of_id_poor         :integer
#  creator_id                :integer
#  locked_at                 :datetime
#  primary_school_code       :string
#  downloaded_count          :integer          default(0)
#  progress                  :integer
#  language_conducted_code   :string
#  finished_date             :datetime
#  running_date              :datetime
#  deleted_at                :datetime
#
FactoryBot.define do
  factory :scorecard do
    year         { Date.today.year }
    program      { create(:program) }
    facility     { create(:facility, :with_parent, program: program) }
    unit_type_id { facility.parent_id }
    creator      { create(:creator, program: program) }
    local_ngo    { create(:local_ngo, program: program) }
    status       { "planned" }
    scorecard_type { Scorecard::SCORECARD_TYPES.sample.last }
    commune_id   { Pumi::Commune.all.sample.id }
    district_id  { Pumi::Commune.find_by_id(commune_id).try(:district_id) }
    province_id  { Pumi::Commune.find_by_id(commune_id).province_id }
    planned_start_date { 7.days.from_now }
    planned_end_date { planned_start_date }

    trait :with_primary_school do
      facility            { create(:facility, :with_parent, :dataset) }
      primary_school_code { PrimarySchool.first.code }
      commune_id          { PrimarySchool.first.commune_id }
    end
  end
end
