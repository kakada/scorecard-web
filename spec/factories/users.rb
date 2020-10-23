# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  program_id             :integer
#  authentication_token   :string           default("")
#  token_expired_date     :datetime
#
FactoryBot.define do
  factory :user do
    email         { FFaker::Internet.email }
    password      { FFaker::Internet.password }
    role          { "program_admin" }
    confirmed_at  { DateTime.now }
    program

    trait :system_admin do
      role { "system_admin" }
      program     { nil }
    end

    trait :staff do
      role { "staff" }
    end

    trait :guest do
      role { "guest" }
    end
  end
end
