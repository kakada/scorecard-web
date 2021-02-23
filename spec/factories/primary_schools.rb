# frozen_string_literal: true

# == Schema Information
#
# Table name: primary_schools
#
#  id         :bigint           not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  commune_id :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :primary_school do
  end
end
