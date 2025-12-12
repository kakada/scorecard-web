# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramClonePolicy do
  subject { described_class }

  let(:program) { create(:program) }
  let(:program_clone) { create(:program_clone, target_program: program) }

  permissions :new?, :create? do
    context "when user is system_admin" do
      let(:user) { User.new(role: :system_admin) }

      it "grants access" do
        expect(subject).to permit(user, ProgramClone.new)
      end
    end

    context "when user is program_admin" do
      let(:user) { User.new(role: :program_admin, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, ProgramClone.new)
      end
    end

    context "when user is staff" do
      let(:user) { User.new(role: :staff, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, ProgramClone.new)
      end
    end

    context "when user is lngo" do
      let(:user) { User.new(role: :lngo, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, ProgramClone.new)
      end
    end
  end

  permissions :show? do
    context "when user is system_admin" do
      let(:user) { User.new(role: :system_admin) }

      it "grants access" do
        expect(subject).to permit(user, program_clone)
      end
    end

    context "when user created the program clone" do
      let(:user) { create(:user, role: :system_admin) }
      let(:program_clone) { create(:program_clone, user: user, target_program: program) }

      it "grants access" do
        expect(subject).to permit(user, program_clone)
      end
    end

    context "when user is not the creator and not system_admin" do
      let(:creator) { create(:user, role: :system_admin) }
      let(:other_user) { create(:user, role: :system_admin) }
      let(:program_clone) { create(:program_clone, user: creator, target_program: program) }

      it "grants access to system admin" do
        expect(subject).to permit(other_user, program_clone)
      end
    end

    context "when user is program_admin" do
      let(:user) { User.new(role: :program_admin, program_id: program.id) }

      it "denies access" do
        expect(subject).not_to permit(user, program_clone)
      end
    end
  end
end
