require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RecrutementBack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1


    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'https://gestionrhback.onrender.com' # Remplacez '*' par votre domaine Angular en production
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
      end
    end


    config.action_dispatch.default_headers = {
      'Content-Security-Policy' => "frame-ancestors 'self' https://gestionrhback.onrender.com"
    }




    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
