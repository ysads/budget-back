Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:9090'

    resource '*',
             credentials: true,
             headers: :any,
             methods: :any
  end
end
