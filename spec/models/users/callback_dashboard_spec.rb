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

    context "user already has a gf_user_id" do
      let!(:user) { create(:user, gf_user_id: 1) }

      before { user.update_column(:confirmed_at, nil) }

      it "does not enqueue add_to_dashboard again" do
        expect {
          user.update(confirmed_at: Time.now, skip_callback: false)
        }.not_to change(UserWorker.jobs, :count)
      end
    end

    context "deactivate a user with no gf_user_id" do
      let!(:user) { create(:user, gf_user_id: nil) }

      it "does not enqueue remove_from_dashboard" do
        expect {
          user.update(actived: false, skip_callback: false)
        }.not_to change(UserWorker.jobs, :count)
      end
    end

    context "skip_callback is true" do
      let!(:user) { create(:user) }

      before { user.update_column(:confirmed_at, nil) }

      it "does not enqueue any job" do
        expect {
          user.update(confirmed_at: Time.now, skip_callback: true)
        }.not_to change(UserWorker.jobs, :count)
      end
    end
  end

  describe "#after_restore, add_to_dashboard" do
    context "restoring a confirmed user" do
      let!(:user) { create(:user, :allow_callback) }

      before { user.destroy }

      it "adds a job to UserWorker" do
        expect {
          user.restore
        }.to change(UserWorker.jobs, :count)
      end

      it "adds the user to dashboard" do
        user.restore

        expect(UserWorker.jobs.last["args"][0]).to eq("add_to_dashboard")
      end
    end
  end

  describe "#after_destroy, remove_from_dashboard" do
    context "destroying a user with a gf_user_id" do
      let!(:user) { create(:user, :allow_callback, gf_user_id: 1) }

      it "adds a job to UserWorker" do
        expect {
          user.destroy
        }.to change(UserWorker.jobs, :count)
      end

      it "removes the user from the dashboard" do
        user.destroy

        expect(UserWorker.jobs.last["args"][0]).to eq("remove_from_dashboard")
      end
    end

    context "destroying a user with no gf_user_id" do
      let!(:user) { create(:user, :allow_callback, gf_user_id: nil) }

      it "does not enqueue a job" do
        expect {
          user.destroy
        }.not_to change(UserWorker.jobs, :count)
      end
    end

    context "skip_callback is true" do
      let!(:user) { create(:user, gf_user_id: 1) }

      it "does not enqueue a job" do
        expect {
          user.destroy
        }.not_to change(UserWorker.jobs, :count)
      end
    end
  end

  describe "#add_to_dashboard" do
    let(:user) { create(:user) }

    context "when the user has a program" do
      it "adds the user to the program's dashboard" do
        dashboard = instance_double(Dashboard, add_user: true)
        allow(Dashboard).to receive(:new).with(user.program).and_return(dashboard)

        user.add_to_dashboard

        expect(dashboard).to have_received(:add_user).with(user)
      end
    end

    context "when the user has no program" do
      before { user.update_column(:program_id, nil) }

      it "does not call Dashboard" do
        expect(Dashboard).not_to receive(:new)

        user.add_to_dashboard
      end
    end
  end

  describe "#remove_from_dashboard" do
    let(:user) { create(:user, gf_user_id: 5) }

    context "when the user has a program" do
      it "removes the user from the program's dashboard and clears gf_user_id" do
        dashboard = instance_double(Dashboard, remove_user: true)
        allow(Dashboard).to receive(:new).with(user.program).and_return(dashboard)

        user.remove_from_dashboard

        expect(dashboard).to have_received(:remove_user).with(user)
        expect(user.reload.gf_user_id).to be_nil
      end
    end

    context "when the user has no program" do
      before { user.update_column(:program_id, nil) }

      it "does not call Dashboard" do
        expect(Dashboard).not_to receive(:new)

        user.remove_from_dashboard
      end
    end
  end
end
