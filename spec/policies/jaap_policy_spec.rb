# frozen_string_literal: true

require "rails_helper"

RSpec.describe JaapPolicy do
  subject { described_class }

  describe "permissions" do
    let(:program) { create(:program) }
    let(:jaap) { create(:jaap, program: program, province_id: "01") }

    permissions :index?, :show? do
      it "allows access for any role" do
        expect(subject).to permit(User.new(role: :staff), jaap)
        expect(subject).to permit(User.new(role: :program_admin), jaap)
        expect(subject).to permit(User.new(role: :lngo), jaap)
        expect(subject).to permit(User.new(role: :system_admin), jaap)
      end
    end

    permissions :new?, :create?, :edit?, :update?, :destroy? do
      it "allows program_admin" do
        user = User.new(role: :program_admin)
        expect(subject).to permit(user, jaap)
      end

      it "allows staff" do
        user = User.new(role: :staff)
        expect(subject).to permit(user, jaap)
      end

      it "allows lngo" do
        user = User.new(role: :lngo)
        expect(subject).to permit(user, jaap)
      end

      it "denies system_admin (not editable_team)" do
        user = User.new(role: :system_admin)
        expect(subject).not_to permit(user, jaap)
      end
    end
  end

  describe "scope" do
    let!(:program1) { create(:program) }
    let!(:program2) { create(:program) }

    let!(:jaap_p1_prov01) { create(:jaap, program: program1, province_id: "01") }
    let!(:jaap_p1_prov02) { create(:jaap, program: program1, province_id: "02") }
    let!(:jaap_p2_prov01) { create(:jaap, program: program2, province_id: "01") }

    def resolve_for(user)
      described_class::Scope.new(user, Jaap).resolve
    end

    it "returns all for system_admin" do
      user = User.new(role: :system_admin)
      expect(resolve_for(user)).to match_array([jaap_p1_prov01, jaap_p1_prov02, jaap_p2_prov01])
    end

    it "returns same-program for program_admin" do
      user = User.new(role: :program_admin, program_id: program1.id)
      expect(resolve_for(user)).to match_array([jaap_p1_prov01, jaap_p1_prov02])
    end

    it "returns same-program for staff" do
      user = User.new(role: :staff, program_id: program1.id)
      expect(resolve_for(user)).to match_array([jaap_p1_prov01, jaap_p1_prov02])
    end

    it "returns same-program and target provinces for lngo" do
      lngo = create(:local_ngo, program: program1, target_province_ids: "01")
      user = User.new(role: :lngo, program_id: program1.id, local_ngo_id: lngo.id)
      expect(resolve_for(user)).to match_array([jaap_p1_prov01])
    end
  end
end
