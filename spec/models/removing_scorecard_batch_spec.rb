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
require "rails_helper"

RSpec.describe RemovingScorecardBatch, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:scorecards) }

  describe "validate #secure_confirmation" do
    context "removing_scorecard_codes is blank" do
      subject { described_class.new(removing_scorecard_codes: []) }

      it "has errors miss matching scorecard codes" do
        subject.valid?
        expect(subject.errors).to include(:scorecards)
      end
    end

    context "removing_scorecard_codes is present but miss match confirm_removing_scorecard_codes" do
      subject { described_class.new(removing_scorecard_codes: ['123456'], confirm_removing_scorecard_codes: "234567,234567") }

      it "has errors miss matching scorecard codes" do
        subject.valid?
        expect(subject.errors).to include(:scorecards)
      end
    end

    context "removing_scorecard_codes is present and match confirm_removing_scorecard_codes" do
      subject { described_class.new(removing_scorecard_codes: ['123456'], confirm_removing_scorecard_codes: "123456") }

      it "has errors miss matching scorecard codes" do
        subject.valid?
        expect(subject.errors).not_to include(:scorecards)
      end
    end
  end

  describe "after_create, soft_delete_scorecards" do
    let!(:user) { create(:user) }
    let!(:scorecard1) { create(:scorecard, program: user.program) }
    let!(:scorecard2) { create(:scorecard) }

    context "different program" do
      let!(:batch) { create(:removing_scorecard_batch, user: user, removing_scorecard_codes: [scorecard1.uuid, scorecard2.uuid], confirm_removing_scorecard_codes: "#{scorecard1.uuid}, #{scorecard2.uuid}") }

      it "deletes only scorecard1" do
        expect(Scorecard.only_deleted.find_by(uuid: scorecard1.uuid)).not_to be_nil
        expect(Scorecard.find_by(uuid: scorecard2.uuid)).not_to be_nil
      end
    end
  end
end
