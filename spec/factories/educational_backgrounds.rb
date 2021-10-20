# frozen_string_literal: true

# == Schema Information
#
# Table name: educational_backgrounds
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_km    :string
#
FactoryBot.define do
  factory :educational_background do
  end
end
