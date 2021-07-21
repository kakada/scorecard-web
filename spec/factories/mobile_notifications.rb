# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_notifications
#
#  id            :bigint           not null, primary key
#  title         :string
#  body          :text
#  success_count :integer
#  failure_count :integer
#  creator_id    :integer
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :mobile_notification do
  end
end
