Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['CORS_ALLOW_ORIGINS'].to_s.split(',')
    resource '*', headers: :any, methods: [:get]
  end
end
