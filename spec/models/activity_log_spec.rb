require 'rails_helper'

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
end
