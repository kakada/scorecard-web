# frozen_string_literal: true

# == Schema Information
#
# Table name: removing_scorecard_batches
#
#  id          :uuid             not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  reference   :string
#  user_id     :integer
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :removing_scorecard_batch do
    user
    program { user.program }
  end
end
