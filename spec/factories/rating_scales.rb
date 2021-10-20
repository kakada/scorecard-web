# frozen_string_literal: true

# == Schema Information
#
# Table name: rating_scales
#
#  id         :bigint           not null, primary key
#  code       :string
#  value      :string
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :rating_scale do
    program
  end
end
