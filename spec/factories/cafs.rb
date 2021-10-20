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
#

FactoryBot.define do
  factory :caf do
    name          { FFaker::Name.name }
    sex           { %w(female male other).sample }
    date_of_birth { rand(18..70).years.ago }
    tel           { FFaker::PhoneNumber.phone_number }
    address       { FFaker::Address.street_name }
    local_ngo
  end
end
