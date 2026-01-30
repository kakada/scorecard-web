# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGuidePolicy, type: :policy do
  subject { described_class }

  permissions :index? do
    context "with authenticated user" do
      it "grants access to system_admin" do
        user = build(:user, :system_admin)
        expect(subject).to permit(user, :user_guide)
      end

      it "grants access to program_admin" do
        user = build(:user, :program_admin, program: build(:program))
        expect(subject).to permit(user, :user_guide)
      end

      it "grants access to staff" do
        user = build(:user, :staff, program: build(:program))
        expect(subject).to permit(user, :user_guide)
      end

      it "grants access to lngo" do
        user = build(:user, :lngo, program: build(:program), local_ngo: build(:local_ngo))
        expect(subject).to permit(user, :user_guide)
      end
    end

    context "without authenticated user" do
      it "denies access" do
        expect(subject).not_to permit(nil, :user_guide)
      end
    end
  end
end
