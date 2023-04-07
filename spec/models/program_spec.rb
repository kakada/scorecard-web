# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  datetime_format           :string           default("YYYY-MM-DD")
#  enable_email_notification :boolean          default(FALSE)
#  shortcut_name             :string
#  dashboard_user_emails     :text             default([]), is an Array
#  dashboard_user_roles      :string           default([]), is an Array
#  uuid                      :string
#
require "rails_helper"

RSpec.describe Program, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:languages) }
  it { is_expected.to have_many(:facilities) }
  it { is_expected.to have_many(:local_ngos) }
  it { is_expected.to have_many(:rating_scales) }
  it { is_expected.to have_one(:data_publication).dependent(:destroy) }
  it { is_expected.to have_many(:data_publication_logs).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }

  describe "#after_create" do
    let!(:program) { create(:program) }

    it { expect(program.languages.length).to eq(1) }
  end

  describe "#after_create, create_dashboard_async" do
    it "adds a job to DashboardWorker" do
      expect {
        create(:program, :allow_callback)
      }.to change(DashboardWorker.jobs, :count)
    end
  end
end
