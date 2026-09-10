# frozen_string_literal: true

require "rails_helper"

RSpec.describe IndicatorActivityCategoryPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :create?, :update?, :destroy? do
    let(:category) { build(:indicator_activity_category) }

    it "allows program_admin" do
      expect(subject).to permit(User.new(role: :program_admin), category)
    end

    it "allows staff" do
      expect(subject).to permit(User.new(role: :staff), category)
    end

    it "denies system_admin" do
      expect(subject).not_to permit(User.new(role: :system_admin), category)
    end

    it "denies lngo" do
      expect(subject).not_to permit(User.new(role: :lngo), category)
    end
  end

  describe "scope" do
    let!(:program1) { create(:program) }
    let!(:program2) { create(:program) }
    let!(:category1) { create(:indicator_activity_category, program: program1) }
    let!(:category2) { create(:indicator_activity_category, program: program2) }

    def resolve_for(user)
      described_class::Scope.new(user, IndicatorActivityCategory).resolve
    end

    it "returns same-program records for staff" do
      user = User.new(role: :staff, program_id: program1.id)
      expect(resolve_for(user)).to match_array([category1])
    end

    it "returns same-program records for program_admin" do
      user = User.new(role: :program_admin, program_id: program2.id)
      expect(resolve_for(user)).to match_array([category2])
    end

    it "returns no records for system_admin" do
      user = User.new(role: :system_admin)
      expect(resolve_for(user)).to be_empty
    end
  end
end
