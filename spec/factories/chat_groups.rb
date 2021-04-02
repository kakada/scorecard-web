# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups
#
#  id         :bigint           not null, primary key
#  title      :string
#  chat_id    :string
#  actived    :boolean          default(TRUE)
#  reason     :text
#  provider   :string
#  program_id :integer
#  chat_type  :string           default("group")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :chat_group do
    program

    trait :telegram do
      title     { "mygroup" }
      chat_type { "group" }
      actived   { true }
      chat_id   { "111" }
      provider  { "Telegram" }
    end
  end
end
