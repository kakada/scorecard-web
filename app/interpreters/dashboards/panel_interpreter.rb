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
        interpret_panel_sql_queries(panel)
      end
    end

    private
      def interpret_panel_links(panel)
        (panel["links"] || []).each do |link|
          dashboard_url = "/d/#{@data['uid']}/#{@data['title'].downcase.split(' ').join('-')}"

          link["url"] = "#{ENV['GF_BASE_URL']}#{dashboard_url}?orgId=#{@program.gf_dashboard.org_id}&viewPanel=#{panel['id']}"
        end
      end

      def interpret_panel_sql_queries(panel)
        panel["targets"].each do |target|
          target["rawSql"] = gsub_program_id(@program, target["rawSql"])
        end
      end
  end
end
