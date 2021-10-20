# frozen_string_literal: true

# == Schema Information
#
# Table name: activity_logs
#
#  id              :bigint           not null, primary key
#  controller_name :string
#  action_name     :string
#  http_format     :string
#  http_method     :string
#  path            :string
#  http_status     :integer
#  user_id         :bigint
#  program_id      :bigint
#  payload         :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :activity_log do
  end
end
