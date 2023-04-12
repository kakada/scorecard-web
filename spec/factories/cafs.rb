# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  sex                       :string
#  date_of_birth             :string
#  tel                       :string
#  address                   :string
#  local_ngo_id              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  actived                   :boolean          default(TRUE)
#  educational_background_id :string
#  scorecard_knowledge_id    :string
#  deleted_at                :datetime
#  province_id               :string
#  district_id               :string
#  commune_id                :string
#

FactoryBot.define do
  factory :caf do
    name          { FFaker::Name.name }
    sex           { %w(female male other).sample }
    date_of_birth { rand(18..70).years.ago }
    tel           { FFaker::PhoneNumber.phone_number }
    address       { FFaker::Address.street_name }
    commune_id    { Pumi::Commune.all.sample.id }
    district_id   { commune_id[0..3] }
    province_id   { commune_id[0..1] }
    local_ngo
  end
end
