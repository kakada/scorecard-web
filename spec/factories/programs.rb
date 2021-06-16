# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  datetime_format           :string           default("DD-MM-YYYY")
#  enable_email_notification :boolean          default(FALSE)
#
FactoryBot.define do
  factory :program do
    name    { FFaker::Name.name }

    skip_callback { true }

    trait :allow_callback do
      skip_callback { false }
    end
  end
end
