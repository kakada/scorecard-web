# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardInterpreter do
  let(:program) { create(:program) }
  let(:template_data) do
    {
      "id" => 99,
      "uid" => "template-uid",
      "title" => "placeholder",
      "links" => [{ "title" => "stale", "type" => "dashboards", "url" => "" }],
      "panels" => [],
      "templating" => { "list" => [] }
    }
  end

  def interpreter_for(locale)
    described_class.new(program, locale).tap do |interpreter|
      allow(interpreter).to receive(:load_json_data).with("dashboard.json").and_return(template_data)
    end
  end

  describe "#initialize" do
    it "defaults to the first locale" do
      expect(described_class.new(program).locale).to eq(GfDashboard::LOCALES.first)
    end

    it "loads the gf_dashboard for the given locale" do
      gf_dashboard = create(:gf_dashboard, program: program, locale: "en")

      expect(described_class.new(program, "en").gf_dashboard).to eq(gf_dashboard)
    end
  end

  describe "#interpreted_message" do
    it "clears the source template's dashboard id so Grafana treats it as new" do
      data = interpreter_for("km").interpreted_message

      expect(data["id"]).to be_nil
    end

    it "reuses the locale's own dashboard_uid when it already has one" do
      create(:gf_dashboard, program: program, locale: "km", dashboard_uid: "km-uid")

      data = interpreter_for("km").interpreted_message

      expect(data["uid"]).to eq("km-uid")
    end

    it "generates a random uid when the locale's dashboard hasn't been created yet" do
      data = interpreter_for("km").interpreted_message

      expect(data["uid"]).to be_present
      expect(data["uid"]).not_to eq("template-uid")
    end

    it "sets the title from the program name and locale" do
      data = interpreter_for("km").interpreted_message

      expect(data["title"]).to eq("Scorecard Dashboard: #{program.name} (KM)")
    end

    context "when the sibling locale's dashboard has not been created yet" do
      it "leaves the template's own links untouched" do
        data = interpreter_for("km").interpreted_message

        expect(data["links"]).to eq([{ "title" => "stale", "type" => "dashboards", "url" => "" }])
      end
    end

    context "when the sibling locale's dashboard exists but has no url yet" do
      before { create(:gf_dashboard, program: program, locale: "en") }

      it "leaves the template's own links untouched" do
        data = interpreter_for("km").interpreted_message

        expect(data["links"]).to eq([{ "title" => "stale", "type" => "dashboards", "url" => "" }])
      end
    end

    context "when the sibling locale's dashboard exists with a url" do
      before do
        create(:gf_dashboard, program: program, locale: "en", dashboard_url: "http://grafana.test/d/en-uid/en-dash")
      end

      it "replaces the template's links with a switch-language link to the other locale" do
        data = interpreter_for("km").interpreted_message

        expect(data["links"]).to eq([{
          "asDropdown" => false,
          "icon" => "external link",
          "includeVars" => false,
          "keepTime" => true,
          "tags" => [],
          "targetBlank" => false,
          "title" => "🌐 English",
          "tooltip" => "",
          "type" => "link",
          "url" => "http://grafana.test/d/en-uid/en-dash"
        }])
      end
    end
  end
end
