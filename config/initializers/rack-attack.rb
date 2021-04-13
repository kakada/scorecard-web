# frozen_string_literal: true

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

# Always allow requests from localhost
# (blocklist & throttles are skipped)
Rack::Attack.safelist("allow from localhost") do |req|
  # safelist IPs semi-colon separate
  safelist_ips = ENV.fetch("SAFELIST_IPS") { "" } .split(";")
  safelist_ips.each do |ip|
    ip == req.ip || "::1" == req.ip
  end
end

# blocklist IPs semi-colon separate
blocklist_ips = ENV.fetch("BLOCKLIST_IPS") { "" } .split(";")
blocklist_ips.each do |ip|
  Rack::Attack.blocklist_ip(ip)
end

# Lockout IP addresses that are hammering your login page.
# After 20 requests in 1 minute, block all requests from that IP for 1 hour.
Rack::Attack.blocklist("allow2ban login scrapers") do |req|
  # `filter` returns false value if request is to your login page (but still
  # increments the count) so request below the limit are not blocked until
  # they hit the limit.  At that point, filter will return true and block.
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 20, findtime: 1.minute, bantime: 1.hour) do
    # The count for the IP is incremented if the return value is truthy.
    req.path == "/sign_in" and req.post?
  end
end

# throttle request
Rack::Attack.throttle("req/ip", limit: ENV["THROTTLE_REQUEST_LIMIT"].to_i, period: ENV["THROTTLE_PERIOD_IN_SECOND"].to_i.second) do |req|
  req.ip
end

Rack::Attack.throttled_response = lambda do |env|
  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  [ 503, {}, ["Internal Server Error"]]
end
