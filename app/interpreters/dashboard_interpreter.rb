# frozen_string_literal: true

class DashboardInterpreter < Dashboards::BaseInterpreter
  attr_reader :program, :locale, :gf_dashboard

  def initialize(program, locale = GfDashboard::LOCALES.first)
    @program = program
    @locale = locale
    @gf_dashboard = program.gf_dashboard(locale)
  end

  def interpreted_message
    data = load_json_data("dashboard.json")
    assign_uid(data)
    assign_title(data)
    assign_locale_switch_link(data)

    %w(panel variable).each do |model|
      "Dashboards::#{model.camelcase}Interpreter".constantize.new(program, data, locale).interpret
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
      data["title"] = "Scorecard Dashboard: #{program.name} (#{locale.upcase})"
    end

    # Lets a viewer jump from one language's dashboard to the other. The
    # sibling dashboard's URL only exists once it has been created at least
    # once, so this link is added/refreshed on every interpretation rather
    # than baked in once. This replaces the template's own placeholder
    # locale-switch link, which points nowhere (empty url).
    def assign_locale_switch_link(data)
      other_locale = (GfDashboard::LOCALES - [locale]).first
      other_dashboard = program.gf_dashboard(other_locale)
      return if other_dashboard.blank? || other_dashboard.dashboard_url.blank?

      data["links"] = [{
        "asDropdown" => false,
        "icon" => "external link",
        "includeVars" => false,
        "keepTime" => true,
        "tags" => [],
        "targetBlank" => false,
        "title" => "🌐 #{GfDashboard::LOCALE_NAMES[other_locale]}",
        "tooltip" => "",
        "type" => "link",
        "url" => other_dashboard.dashboard_url
      }]
    end
end
