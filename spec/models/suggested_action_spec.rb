# frozen_string_literal: true

# == Schema Information
#
# Table name: suggested_actions
#
#  id                    :bigint           not null, primary key
#  voting_indicator_uuid :string
#  content               :string
#  selected              :boolean
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require "rails_helper"

RSpec.describe SuggestedAction, type: :model do
  it { is_expected.to belong_to(:scorecard).optional }
  it { is_expected.to belong_to(:voting_indicator).optional }
end
