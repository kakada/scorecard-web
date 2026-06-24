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
#  enable_auto_complete_submitted_scorecard :boolean          default(FALSE)
#  auto_complete_submitted_scorecard_in_days :integer          default(15), not null
#  shortcut_name             :string
#  dashboard_user_emails     :text             default([]), is an Array
#  dashboard_user_roles      :string           default([]), is an Array
#  uuid                      :string
#  sandbox                   :boolean          default(FALSE), not null
#
FactoryBot.define do
  factory :program do
    name    { FFaker::Name.name }
    shortcut_name {
      start = rand(0..9)
      en = rand(start+1..start+10)
      Devise.friendly_token[start..en]
    }
    skip_callback { true }

    trait :allow_callback do
      skip_callback { false }
    end
  end
end
