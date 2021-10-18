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
require "rails_helper"

RSpec.describe ActivityLog, type: :model do
  it { is_expected.to have_attribute(:controller_name) }
  it { is_expected.to have_attribute(:action_name) }
  it { is_expected.to have_attribute(:path) }
  it { is_expected.to have_attribute(:http_method) }
  it { is_expected.to have_attribute(:http_format) }
  it { is_expected.to have_attribute(:http_status) }
  it { is_expected.to have_attribute(:payload) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:program).optional }

  describe "Delegate" do
    let(:activity_log) { create(:activity_log, user: build(:user)) }

    context "without program" do
      before { activity_log.program = nil }

      specify { expect(activity_log.program_name).to be_blank }
    end

    context "with program" do
      let(:program) { build(:program, name: "my program") }

      before { activity_log.program = program }

      specify { expect(activity_log.program_name).to eq("my program") }
    end
  end

  describe "ActivityLog::RoledScope" do
    let(:program1) { create(:program) }
    let(:program2) { create(:program) }

    let(:staff)         { create(:user, :staff, program: program1) }
    let(:program_admin) { create(:user, program: program1) }
    let(:system_admin)  { create(:user, :system_admin) }

    let(:staff_log)         { create(:activity_log, user: staff, program: staff.program) }
    let(:program_admin_log) { create(:activity_log, user: program_admin, program: program_admin.program) }
    let(:system_admin_log)  { create(:activity_log, user: system_admin, program: system_admin.program) }

    context "As staff" do
      it "shows staff logs" do
        params = { role: staff.role, user_id: staff.id, program_id: staff.program_id }
        expect(described_class.filter(params)).to match_array [staff_log]
      end
    end

    context "As program admin" do
      it "shows program logs" do
        params = { role: program_admin.role, user_id: program_admin.id, program_id: program_admin.program_id }
        expect(described_class.filter(params)).to match_array [staff_log, program_admin_log]
      end
    end

    context "As system admin" do
      it "shows all logs" do
        params = { role: system_admin.role, user_id: system_admin.id, program_id: system_admin.program_id }
        expect(described_class.filter(params)).to match_array [staff_log, program_admin_log, system_admin_log]
      end
    end
  end

  describe "Unique request within loggable period" do
    let(:user) { create(:user) }
    let!(:activity_log) { create(:activity_log, http_method: 'get', path: '/scorecards', user: user) }

    before {
      stub_const('ENV', {'ACTIVITY_LOGGABLE_PERIODIC_IN_MINUTE' => '5' })
    }

    context "with GET request" do
      let(:new_activity_log) { build(:activity_log, http_method: 'get', path: '/scorecards', user: user) }

      specify { expect(new_activity_log).to be_invalid }
      it "raises exception" do
        expect {
          new_activity_log.save!
        }.to raise_error(ActiveRecord::RecordInvalid, /Request duplicate/)
      end

      context "when last activity older than current activity" do
        before { activity_log.update(created_at: 10.minutes.ago) }
        specify { expect(new_activity_log).to be_valid }
      end

      context "with different path" do
        before { new_activity_log.update(path: '/new-path') }
        specify { expect(new_activity_log).to be_valid }
      end
    end

    context "with non-GET request" do
      let(:new_activity_log) { build(:activity_log, http_method: 'post', path: '/scorecards', user: user) }

      specify { expect(new_activity_log).to be_valid }

      it "creates more than one" do
        expect {
          ActivityLog.create(new_activity_log.attributes)
          ActivityLog.create(new_activity_log.attributes)
        }.to change { ActivityLog.count }.by 2
      end
    end
  end
end
