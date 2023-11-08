# frozen_string_literal: true

class DashboardInterpreter < Dashboards::BaseInterpreter
  attr_reader :program, :gf_dashboard

  def initialize(program)
    @program = program
    @gf_dashboard = program.gf_dashboard
  end

  def interpreted_message
    data = load_json_data("dashboard.json")
    assign_uid(data)
    assign_title(data)

    %w(panel variable).each do |model|
      "Dashboards::#{model.camelcase}Interpreter".constantize.new(program, data).interpret
      rescue
        Rails.logger.warn "Model Dashboards::#{model.camelcase}Interpreter is unknwon"
    end

    data
  end

  private
    def assign_uid(data)
      data["id"] = nil
      data["uid"] = gf_dashboard.try(:dashboard_uid) || SecureRandom.uuid[1..9]
    end

    def assign_title(data)
      data["title"] = "Scorecard Dashboard: #{program.name}"
    end
end
