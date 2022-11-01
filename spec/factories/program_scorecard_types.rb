# frozen_string_literal: true

# == Schema Information
#
# Table name: program_scorecard_types
#
#  id         :uuid             not null, primary key
#  code       :integer
#  name_en    :string
#  name_km    :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :program_scorecard_type do
  end
end
