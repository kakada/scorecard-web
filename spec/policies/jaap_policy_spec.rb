# frozen_string_literal: true

require "rails_helper"

RSpec.describe JaapPolicy do
  subject { described_class }

  let(:program) { create(:program) }
  let(:other_program) { create(:program) }

  permissions :index? do
    it "grants access to all users" do
      user = create(:user)
      expect(subject).to permit(user, Jaap)
    end
  end

  permissions :show? do
    context "when jaap is under different program" do
      let(:jaap) { create(:jaap, program: other_program) }
      let(:user) { create(:user, :staff, program: program) }

      it "denies access" do
        expect(subject).not_to permit(user, jaap)
      end
    end

    context "when jaap is under the same program and user is staff" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :staff, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end

    context "when jaap is under the same program and user is program_admin" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :program_admin, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end

    context "when user is system_admin" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :system_admin) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end
  end

  permissions :create? do
    context "when user is staff" do
      let(:user) { create(:user, :staff, program: program) }

      it "grants access" do
        expect(subject).to permit(user, Jaap)
      end
    end

    context "when user is program_admin" do
      let(:user) { create(:user, :program_admin, program: program) }

      it "grants access" do
        expect(subject).to permit(user, Jaap)
      end
    end

    context "when user is lngo" do
      let(:user) { create(:user, :lngo, program: program) }

      it "denies access" do
        expect(subject).not_to permit(user, Jaap)
      end
    end
  end

  permissions :update? do
    context "when user is staff" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :staff, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end

    context "when user is program_admin" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :program_admin, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end
  end

  permissions :destroy? do
    context "when user is staff" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :staff, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end

    context "when user is program_admin" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :program_admin, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end
  end

  permissions :complete? do
    context "when user is staff" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :staff, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end

    context "when user is program_admin" do
      let(:jaap) { create(:jaap, program: program) }
      let(:user) { create(:user, :program_admin, program: program) }

      it "grants access" do
        expect(subject).to permit(user, jaap)
      end
    end
  end
end
