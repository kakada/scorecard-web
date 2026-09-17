# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                                        :bigint           not null, primary key
#  name                                      :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  datetime_format                           :string           default("DD-MM-YYYY")
#  enable_email_notification                 :boolean          default(FALSE)
#  shortcut_name                             :string
#  dashboard_user_emails                     :text             default([]), is an Array
#  dashboard_user_roles                      :string           default([]), is an Array
#  uuid                                      :string
#  sandbox                                   :boolean          default(FALSE), not null
#  enable_auto_complete_submitted_scorecard  :boolean          default(FALSE)
#  auto_complete_submitted_scorecard_in_days :integer          default(15), not null
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
  it { is_expected.to have_many(:indicator_activity_categories) }
  it { is_expected.to have_many(:gf_dashboards).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_numericality_of(:auto_complete_submitted_scorecard_in_days).only_integer.is_greater_than(0) }

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

  describe "#gf_dashboard" do
    let(:program) { create(:program) }

    it "defaults to the km locale" do
      gf_dashboard = create(:gf_dashboard, program: program, locale: "km")

      expect(program.gf_dashboard).to eq(gf_dashboard)
    end

    it "finds the gf_dashboard for the given locale" do
      gf_dashboard = create(:gf_dashboard, program: program, locale: "en")

      expect(program.gf_dashboard("en")).to eq(gf_dashboard)
    end
  end

  describe "#create_dashboard" do
    let(:program) { create(:program) }

    it "creates one dashboard per locale, then refreshes them all" do
      GfDashboard::LOCALES.each do |locale|
        dashboard = instance_double(Dashboard, create: true)
        expect(Dashboard).to receive(:new).with(program, locale).and_return(dashboard)
      end
      expect(program).to receive(:update_dashboard)

      program.create_dashboard
    end
  end

  describe "#update_dashboard" do
    let(:program) { create(:program) }

    it "updates one dashboard per locale" do
      GfDashboard::LOCALES.each do |locale|
        dashboard = instance_double(Dashboard, update: true)
        expect(Dashboard).to receive(:new).with(program, locale).and_return(dashboard)
      end

      program.update_dashboard
    end
  end
end
