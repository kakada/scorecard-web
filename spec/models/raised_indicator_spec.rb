# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                    :bigint           not null, primary key
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  tag_id                :integer
#  participant_uuid      :string
#  selected              :boolean          default(FALSE)
#  voting_indicator_uuid :string
#  indicator_uuid        :string
#
require "rails_helper"

RSpec.describe RaisedIndicator, type: :model do
  it { is_expected.to belong_to(:scorecard).optional }
  it { is_expected.to belong_to(:indicator).optional }
  it { is_expected.to belong_to(:voting_indicator).optional }
end
