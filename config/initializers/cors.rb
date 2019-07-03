
    # Rails 5

 Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*', 
           :headers => :any,
           :expose  => ['acces-token', 'sxpiry', 'token-type', 'uid', 'client']]
           :methods => [:get, :post, :put, :path, :delete, :options, :head]
      end
    end

