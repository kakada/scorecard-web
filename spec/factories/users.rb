# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
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
#  language_code          :string           default("en")
#  unlock_token           :string
#  locked_at              :datetime
#  failed_attempts        :integer          default(0)
#  local_ngo_id           :integer
#  actived                :boolean          default(TRUE)
#  gf_user_id             :integer
#
FactoryBot.define do
  factory :user, aliases: [:creator] do
    email         { FFaker::Internet.email }
    password      { FFaker::Internet.password }
    role          { "program_admin" }
    confirmed_at  { DateTime.now }
    program       { create(:program) }
    skip_callback { true }

    trait :allow_callback do
      skip_callback { false }
    end

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

    trait :lngo do
      role { "lngo" }
      local_ngo_id { create(:local_ngo).id }
    end
  end
end
