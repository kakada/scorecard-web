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
    district_id  { "001" }
    commune_id   { "0001" }
    data         { {} }
    program
  end
end
