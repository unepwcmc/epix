require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Epix
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #
    config.eager_load_paths += %W(#{config.root}/lib/modules)

    # Load shared assets from epix_frontend
    config.assets.paths << "#{Rails.root}/app/assets/shared/stylesheets"
    config.assets.paths << "#{Rails.root}/app/assets/shared/javascripts"
    config.assets.paths << "#{Rails.root}/app/assets/shared/fonts"
  end
end
