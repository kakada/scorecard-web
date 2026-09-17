# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dashboard, type: :model do
  let(:program) { create(:program) }

  describe "#initialize" do
    it "defaults to the first locale" do
      dashboard = Dashboard.new(program)

      expect(dashboard.locale).to eq(GfDashboard::LOCALES.first)
    end

    it "finds or builds the gf_dashboard for the given locale" do
      existing = create(:gf_dashboard, program: program, locale: "en")

      expect(Dashboard.new(program, "en").gf_dashboard).to eq(existing)
      expect(Dashboard.new(program, "km").gf_dashboard).not_to be_persisted
    end
  end

  describe "#ensure_org!" do
    subject(:dashboard) { Dashboard.new(program, "en") }

    context "when the program has no gf_dashboard with an org yet" do
      it "bootstraps the org, token and datasource" do
        expect(dashboard).to receive(:create_org)
        expect(dashboard).to receive(:switch_to_current_org)
        expect(dashboard).to receive(:create_org_token)
        expect(dashboard).to receive(:create_datasource)

        dashboard.ensure_org!
      end
    end

    context "when another locale already created the org" do
      before { create(:gf_dashboard, program: program, locale: "km", org_id: 1, org_token: "token") }

      it "reuses the existing org credentials instead of creating a new org" do
        expect(dashboard).not_to receive(:create_org)
        expect(dashboard).not_to receive(:create_datasource)

        dashboard.ensure_org!

        expect(dashboard.gf_dashboard.org_id).to eq(1)
        expect(dashboard.gf_dashboard.org_token).to eq("token")
      end
    end
  end

  describe "#update" do
    it "does nothing when the locale's gf_dashboard has not been created yet" do
      dashboard = Dashboard.new(program, "en")

      expect(dashboard).not_to receive(:upsert_with_token)
      expect(dashboard.update).to be_nil
    end
  end
end
