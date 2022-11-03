# frozen_string_literal: true

module Dashboards
  class PanelInterpreter < BaseInterpreter
    def initialize(program, data)
      @program = program
      @data = data
    end

    def interpret
      @data["panels"].each do |panel|
        interpret_panel_links(panel)
        interpret_panel_geospatial_map(panel)
        interpret_panel_sql_queries(panel)
        interpret_panel_scorecard_type(panel)
      end
    end

    private
      def interpret_panel_links(panel)
        (panel["links"] || []).each do |link|
          dashboard_url = "/d/#{@data['uid']}/#{@data['title'].downcase.split(' ').join('-')}"

          link["url"] = "#{ENV['GF_DASHBOARD_BASE_URL']}#{dashboard_url}?orgId=#{@program.gf_dashboard.org_id}&viewPanel=#{panel['id']}"
        end
      end

      def interpret_panel_geospatial_map(panel)
        return unless panel["options"].present? && panel["viewType"] == "geospatial"

        panel["options"]["geospatial"]["geoJsonUrl"] = ENV["GEO_JSON_URL"]
      end

      def interpret_panel_sql_queries(panel)
        panel["targets"].each do |target|
          target["rawSql"] = gsub_program_id(@program, target["rawSql"])
        end
      end

      def interpret_panel_scorecard_type(panel)
        return unless panel["title"].include? "វាយតម្លៃខ្លួនឯង"

        gsub_scorecard_type(panel["title"])
        gsub_scorecard_type(panel["description"])

        panel["fieldConfig"]["overrides"].each do |config|
          gsub_scorecard_type(config["matcher"]["options"])
        end

        panel["targets"].each do |target|
          gsub_scorecard_type(target["rawSql"])
        end
      end

      def gsub_scorecard_type(content)
        words = [["វាយតម្លៃខ្លួនឯង", self_assessment.name_km], ["ប័ណ្ណដាក់ពិន្ទុសហគមន៍", community_scorecard.name_km]]
        words.each do |word|
          content.gsub!(/#{word[0]}/, word[1])
        end
      end

      def self_assessment
        @self_assessment ||= @program.program_scorecard_types.find_by(code: 'self_assessment')
      end

      def community_scorecard
        @community_scorecard ||= @program.program_scorecard_types.find_by(code: 'community_scorecard')
      end
  end
end
