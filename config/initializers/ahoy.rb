class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    ActivityLogsWorker.perform_async(data.with_indifferent_access)
    super(data)
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Only whitelisted controllers
Ahoy.exclude_method = lambda do |controller, request|
  not ActivityLog.whitelist_controllers.include?(controller.name)
end
