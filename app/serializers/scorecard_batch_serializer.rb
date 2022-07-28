# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_item     :integer          default(0)
#  total_valid    :integer          default(0)
#  total_province :integer          default(0)
#  total_district :integer          default(0)
#  total_commune  :integer          default(0)
#  user_id        :integer
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  filename       :string
#
class ScorecardBatchSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :program_id
end
