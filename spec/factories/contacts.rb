# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id           :bigint           not null, primary key
#  contact_type :integer
#  value        :string
#  program_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :contact do
    contact_type   { :tel }
    value          { FFaker::PhoneNumber.short_phone_number }
    program

    trait :email do
      contact_type { :email }
      value        { FFaker::Internet.email }
    end
  end
end
