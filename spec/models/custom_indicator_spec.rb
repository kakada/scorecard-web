# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  scorecard_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tag_id         :integer
#  uuid           :string
#
require "rails_helper"

RSpec.describe CustomIndicator, type: :model do
  it { is_expected.to belong_to(:tag).optional }
  it { is_expected.to belong_to(:scorecard) }
  it { is_expected.to validate_presence_of(:name) }
end
