Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins *ENV.fetch('CORS_ORIGINS', 'localhost').split(',').map { |s| Regexp.new(s) }

    resource '*',
             credentials: true,
             headers: :any,
             methods: :any
  end
end
