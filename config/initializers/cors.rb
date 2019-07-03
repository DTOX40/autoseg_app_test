 Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*', 
        methods: [:get, :post, :delete, :put, :patch, :options, :head],
        headers: :any,
        expose: ['acces-token', 'expity' 'token-type', 'uid', 'client']
      end
    
end    


