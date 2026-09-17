# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                                        :bigint           not null, primary key
#  name                                      :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  datetime_format                           :string           default("DD-MM-YYYY")
#  enable_email_notification                 :boolean          default(FALSE)
#  shortcut_name                             :string
#  dashboard_user_emails                     :text             default([]), is an Array
#  dashboard_user_roles                      :string           default([]), is an Array
#  uuid                                      :string
#  sandbox                                   :boolean          default(FALSE), not null
#  enable_auto_complete_submitted_scorecard  :boolean          default(FALSE)
#  auto_complete_submitted_scorecard_in_days :integer          default(15), not null
#
FactoryBot.define do
  factory :program do
    name    { FFaker::Name.name }
    shortcut_name { Devise.friendly_token(12) }
    skip_callback { true }

    trait :allow_callback do
      skip_callback { false }
    end
  end
end
