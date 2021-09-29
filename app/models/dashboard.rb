# frozen_string_literal: true

require "uri"
require "net/http"
require "httparty"
require "json"
require "openssl"

class Dashboard
  include HTTParty
  base_uri ENV["GF_DASHBOARD_BASE_URL"]

  attr_reader :program, :gf_dashboard

  def initialize(program)
    @program = program
    @gf_dashboard = program.gf_dashboard || program.build_gf_dashboard
  end

  def create
    create_org
    switch_to_current_org
    create_org_token
    create_datasource
    create_dashboard
    set_default_dashboard
  end

  def create_org
    option = { basic_auth: auth, body: { name: program.name } }

    result = self.class.post("/api/orgs", option)
    gf_dashboard.update(org_id: result.parsed_response["orgId"]) if result.response.is_a?(Net::HTTPSuccess)
  end

  def switch_to_current_org
    option = { basic_auth: auth, body: {} }

    self.class.post("/api/user/using/#{gf_dashboard.org_id}", option)
  end

  def create_org_token
    option = { basic_auth: auth, body: { name: "#{program.name}_apikey", role: "Admin" } }

    result = self.class.post("/api/auth/keys", option)
    gf_dashboard.update(org_token: result.parsed_response["key"]) if result.response.is_a?(Net::HTTPSuccess)
  end

  def create_datasource
    params = JSON.dump(DatasourceInterpreter.new(program).interpreted_message)
    upsert_with_token("/api/datasources", params)
  end

  def create_dashboard
    params = JSON.dump({ dashboard: DashboardInterpreter.new(program).interpreted_message, overwrite: false })
    res = upsert_with_token("/api/dashboards/db", params)

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)
      gf_dashboard.update(dashboard_id: data["id"], dashboard_uid: data["uid"], dashboard_url: data["url"])
    end
  end

  def set_default_dashboard
    params = JSON.dump({ theme: "light", homeDashboardId: gf_dashboard.dashboard_id })

    upsert_with_token('/api/org/preferences', params, 'put')
  end

  def add_user(user)
    option = {
      basic_auth: auth,
      body: {
        name: user.display_name,
        email: user.email,
        login: user.email,
        password: SecureRandom.uuid,
        org_id: gf_dashboard.org_id
      }
    }

    result = self.class.post("/api/admin/users", option)
    user.update(gf_user_id: result.parsed_response["id"]) if result.response.is_a?(Net::HTTPSuccess)
  end

  def remove_user(user)
    option = { basic_auth: auth, body: {} }

    result = self.class.delete("/api/admin/users/#{user.gf_user_id}", option)
    user.update(gf_user_id: nil) if result.response.is_a?(Net::HTTPSuccess)
  end

  private
    def auth
      { username: ENV["GF_DASHBOARD_ADMIN_USERNAME"], password: ENV["GF_DASHBOARD_ADMIN_PASSWORD"] }
    end

    def upsert_with_token(endpoint, params, action='post')
      uri = URI.parse("#{ENV['GF_DASHBOARD_BASE_URL']}#{endpoint}")
      req_options = { use_ssl: uri.scheme == "https", verify_mode: OpenSSL::SSL::VERIFY_NONE }

      request = action == 'post' ? Net::HTTP::Post.new(uri) : Net::HTTP::Put.new(uri)
      request.content_type = "application/json"
      request["Authorization"] = "Bearer #{gf_dashboard.org_token}"
      request.body = params

      Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
end
