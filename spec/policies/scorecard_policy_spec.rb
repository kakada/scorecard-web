# frozen_string_literal: true

require "rails_helper"

RSpec.describe ScorecardPolicy do
  subject { described_class }
  let(:lngo) { create(:local_ngo) }

  permissions :show? do
    context "scorecard is under different local ngo" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is under the same local ngo" do
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is staff" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :staff, program_id: scorecard.program_id) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is program_admin" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin, program_id: scorecard.program_id) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end
  end

  permissions :update? do
    context "user is staff" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :staff) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is program_admin" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "scorecard is locked" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin) }

      before {
        scorecard.lock_access!
      }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end
  end

  permissions :download? do
    context "scorecard is under different program_id" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is under different local ngo" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is under the same local ngo" do
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is staff" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :staff, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "user is program_admin" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end
  end

  permissions :submit? do
    context "scorecard is under different program_id" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is under different local ngo" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is locked" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :staff, program_id: scorecard.program_id) }

      before {
        scorecard.lock_submit!
      }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is under the same local ngo" do
      let(:scorecard) { create(:scorecard, local_ngo_id: lngo.id) }
      let(:user) { User.new(role: :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "accept access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is staff" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :staff, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "user is program_admin" do
      let(:scorecard) { create(:scorecard) }
      let(:user) { User.new(role: :program_admin, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end
  end

  permissions :reject? do
    context "user is program admin and scorecard is completed" do
      let(:scorecard) { create(:scorecard, progress: :completed, local_ngo_id: lngo.id) }
      let(:user) { create(:user, :program_admin, program_id: scorecard.program_id) }

      it "permits access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "user is staff and scorecard is in review" do
      let(:scorecard) { create(:scorecard, progress: :in_review, local_ngo_id: lngo.id) }
      let(:user) { create(:user, :staff, program_id: scorecard.program_id) }

      it "permits access" do
        expect(subject).to permit(user, scorecard)
      end
    end

    context "scorecard is rejected" do
      let(:scorecard) { create(:scorecard, :completed, :rejected, local_ngo_id: lngo.id) }
      let(:user) { create(:user, :program_admin, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "scorecard is neither in review nor completed" do
      let(:scorecard) { create(:scorecard, progress: :planned, local_ngo_id: lngo.id) }
      let(:user) { create(:user, :program_admin, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end

    context "user is local ngo (not program admin or staff)" do
      let(:scorecard) { create(:scorecard, progress: :completed, local_ngo_id: lngo.id) }
      let(:user) { create(:user, :lngo, local_ngo_id: lngo.id, program_id: scorecard.program_id) }

      it "denies access" do
        expect(subject).not_to permit(user, scorecard)
      end
    end
  end
end
