# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dashboards::PanelInterpreter do
  let(:program) { create(:program) }
  let(:data) { { "uid" => "dash-uid", "title" => "Scorecard Dashboard", "panels" => panels } }

  before { create(:gf_dashboard, program: program, locale: "km", org_id: 5) }

  around do |example|
    original_base_url = ENV["GF_DASHBOARD_BASE_URL"]
    original_geo_json_url = ENV["GEO_JSON_URL"]
    ENV["GF_DASHBOARD_BASE_URL"] = "http://grafana.test"
    ENV["GEO_JSON_URL"] = "http://geo.test/provinces.json"

    example.run

    ENV["GF_DASHBOARD_BASE_URL"] = original_base_url
    ENV["GEO_JSON_URL"] = original_geo_json_url
  end

  describe "#interpret" do
    context "panel links" do
      let(:panels) do
        [{
          "id" => 17,
          "links" => [{ "title" => "View full screen" }],
          "targets" => []
        }]
      end

      it "builds the full-screen link url from the dashboard uid, title, org id and panel id" do
        described_class.new(program, data, "km").interpret

        expect(panels.first["links"].first["url"])
          .to eq("http://grafana.test/d/dash-uid/scorecard-dashboard?orgId=5&viewPanel=17")
      end
    end

    context "geospatial map panel" do
      let(:panels) do
        [{
          "id" => 1,
          "viewType" => "geospatial",
          "options" => { "geospatial" => { "geoJsonUrl" => "http://stale.example/provinces.json" } },
          "targets" => []
        }]
      end

      it "overrides the geoJsonUrl with the GEO_JSON_URL env var" do
        described_class.new(program, data, "km").interpret

        expect(panels.first["options"]["geospatial"]["geoJsonUrl"]).to eq("http://geo.test/provinces.json")
      end
    end

    context "panel that is not a geospatial map" do
      let(:panels) do
        [{
          "id" => 2,
          "viewType" => "timeseries",
          "options" => { "geospatial" => { "geoJsonUrl" => "http://stale.example/provinces.json" } },
          "targets" => []
        }]
      end

      it "leaves the geoJsonUrl untouched" do
        described_class.new(program, data, "km").interpret

        expect(panels.first["options"]["geospatial"]["geoJsonUrl"]).to eq("http://stale.example/provinces.json")
      end
    end

    context "panel sql queries" do
      let(:panels) do
        [{
          "id" => 3,
          "targets" => [{ "rawSql" => "select * from scorecards where program_id in (${program_id})" }]
        }]
      end

      it "substitutes the program_id placeholder with the program's actual id" do
        described_class.new(program, data, "km").interpret

        expect(panels.first["targets"].first["rawSql"])
          .to eq("select * from scorecards where program_id in (#{program.id})")
      end
    end

    context "panel and target datasource" do
      let(:panels) do
        [{
          "id" => 4,
          "datasource" => { "type" => "postgres", "uid" => "some-uid" },
          "targets" => [{ "datasource" => { "type" => "postgres", "uid" => "some-uid" }, "rawSql" => "" }]
        }]
      end

      it "removes the datasource from the panel and every target" do
        described_class.new(program, data, "km").interpret

        expect(panels.first).not_to have_key("datasource")
        expect(panels.first["targets"].first).not_to have_key("datasource")
      end
    end
  end
end
