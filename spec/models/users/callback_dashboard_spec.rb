# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::CallbackDashboard, type: :model do
  describe "after_create, add_to_dashboard" do
    context "create new user and have confirmed" do
      let(:user) { create(:user) }

      it "adds an job to UserWorker" do
        expect {
          user.update(confirmed_at: Time.now, skip_callback: false)
        }.to change(UserWorker.jobs, :count)
      end

      it "adds the user to dashboard" do
        create(:user, :allow_callback)

        expect(UserWorker.jobs.last["args"][0]).to eq("add_to_dashboard")
      end
    end
  end

  describe "#after_update, add_to_dashboard" do
    context "user set to confirmed" do
      let(:user) { create(:user) }

      before {
        user.update(confirmed_at: nil, skip_callback: false)
        user.update(confirmed_at: Time.now, skip_callback: false)
      }

      it "adds the user to dashboard" do
        expect(UserWorker.jobs.last["args"][0]).to eq("add_to_dashboard")
      end

      it "adds an job to UserWorker" do
        expect {
          user.update(confirmed_at: Time.now, skip_callback: false)
        }.to change(UserWorker.jobs, :count)
      end
    end

    context "deactivate user" do
      let!(:user) { create(:user, gf_user_id: 1) }

      it "adds a job to UserWorker" do
        expect {
          user.update(actived: false, skip_callback: false)
        }.to change(UserWorker.jobs, :count)
      end

      it "remove user from the dashboard" do
        user.update(actived: false, skip_callback: false)

        expect(UserWorker.jobs.last["args"][0]).to eq("remove_from_dashboard")
      end
    end

    context "activate user" do
      let!(:user) { create(:user, actived: false) }

      it "adds a job to UserWorker" do
        expect {
          user.update(actived: true, skip_callback: false)
        }.to change(UserWorker.jobs, :count)
      end

      it "remove user from the dashboard" do
        user.update(actived: true, skip_callback: false)

        expect(UserWorker.jobs.last["args"][0]).to eq("add_to_dashboard")
      end
    end
  end
end
