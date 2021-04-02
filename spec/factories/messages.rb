# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  milestone  :string
#  program_id :integer
#  actived    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :message do
    content   { "message" }
    program
  end
end
