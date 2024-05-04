Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:8080' # Ajuste para o domínio/porta do seu Vue app
      resource '*',
        headers: :any,
        methods: [:get, :post, :patch, :put, :delete, :options, :head],
        credentials: true
    end
  end