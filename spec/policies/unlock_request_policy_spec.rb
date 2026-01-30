# frozen_string_literal: true

require "rails_helper"

RSpec.describe UnlockRequestPolicy do
  subject { described_class }
  let(:lngo) { create(:local_ngo) }
  let(:program) { create(:program) }

  permissions :create? do
    context "user is lngo" do
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:unlock_request) { build(:unlock_request, scorecard: scorecard) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: program.id) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is staff" do
      let(:scorecard) { create(:scorecard) }
      let(:unlock_request) { build(:unlock_request, scorecard: scorecard) }
      let(:user) { User.new(role: :staff, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end

    context "user is program_admin" do
      let(:scorecard) { create(:scorecard) }
      let(:unlock_request) { build(:unlock_request, scorecard: scorecard) }
      let(:user) { User.new(role: :program_admin, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end
  end

  permissions :update? do
    context "user is proposer and unlock_request is pending" do
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: user, status: :pending) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is not proposer" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer, status: :pending) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end

    context "unlock_request is approved" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer) }

      it "denies access" do
        unlock_request.update(status: :approved, reviewer_id: user.id)
        expect(subject).not_to permit(user, unlock_request)
      end
    end
  end

  permissions :review? do
    context "user is program_admin and unlock_request is pending" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { User.new(role: :program_admin, program_id: program.id) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer, status: :pending) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is staff and unlock_request is pending" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { User.new(role: :staff, program_id: program.id) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer, status: :pending) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is lngo" do
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: user, status: :pending) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end

    context "unlock_request is approved" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { User.new(role: :program_admin, program_id: program.id) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer) }

      it "denies access" do
        unlock_request.update(status: :approved, reviewer_id: user.id)
        expect(subject).not_to permit(user, unlock_request)
      end
    end
  end

  permissions :approve? do
    context "user is program_admin and unlock_request is pending" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { User.new(role: :program_admin, program_id: program.id) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer, status: :pending) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is lngo" do
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: user, status: :pending) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end
  end

  permissions :reject? do
    context "user is program_admin and unlock_request is pending" do
      let(:proposer) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:user) { User.new(role: :program_admin, program_id: program.id) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: proposer, status: :pending) }

      it "accepts access" do
        expect(subject).to permit(user, unlock_request)
      end
    end

    context "user is lngo" do
      let(:user) { create(:user, :lngo, local_ngo: lngo, program: program) }
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id, program: program) }
      let(:unlock_request) { create(:unlock_request, scorecard: scorecard, proposer: user, status: :pending) }

      it "denies access" do
        expect(subject).not_to permit(user, unlock_request)
      end
    end
  end
end
