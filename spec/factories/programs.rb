# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  datetime_format :string           default("DD-MM-YYYY")
#
FactoryBot.define do
  factory :program do
    name    { FFaker::Name.name }
  end
end
