# frozen_string_literal: true

module Dashboards
  class PanelInterpreter < BaseInterpreter
    def initialize(program, data, locale = GfDashboard::LOCALES.first)
      @program = program
      @data = data
      @locale = locale
    end

    def interpret
      @data["panels"].each do |panel|
        interpret_panel_links(panel)
        interpret_panel_geospatial_map(panel)
        interpret_panel_sql_queries(panel)
        interpret_panel_datasource(panel)
      end
    end

    private
      # The template's datasource UID is baked in from wherever it was exported;
      # keeping it points panels at a datasource that doesn't exist in this org, breaking with a 404.
      def interpret_panel_datasource(panel)
        panel.delete("datasource")

        (panel["targets"] || []).each { |target| target.delete("datasource") }
      end

      def interpret_panel_links(panel)
        (panel["links"] || []).each do |link|
          dashboard_url = "/d/#{@data['uid']}/#{@data['title'].downcase.split(' ').join('-')}"

          link["url"] = "#{ENV['GF_DASHBOARD_BASE_URL']}#{dashboard_url}?orgId=#{@program.gf_dashboard(@locale).org_id}&viewPanel=#{panel['id']}"
        end
      end

      # Because the geospatial map's GeoJSON URL is environment-specific, we override it here.
      def interpret_panel_geospatial_map(panel)
        return unless panel["options"].present? && panel["viewType"] == "geospatial"

        panel["options"]["geospatial"]["geoJsonUrl"] = ENV["GEO_JSON_URL"]
      end

      # Update query to replace the program ID placeholder with the actual program ID.
      def interpret_panel_sql_queries(panel)
        panel["targets"].each do |target|
          target["rawSql"] = gsub_program_id(@program, target["rawSql"])
        end
      end
  end
end
