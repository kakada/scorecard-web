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
#
require "rails_helper"

RSpec.describe ScorecardBatch, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many(:scorecards).with_foreign_key(:scorecard_batch_code).with_primary_key(:code) }

  describe "#before_create, set_code" do
    let(:subject) { create(:scorecard_batch, code: nil) }

    it { expect(subject.code).not_to be_nil }
  end
end
