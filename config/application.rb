require_relative 'boot'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Potepanec
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # Load application's model / class decorators
    initializer 'spree.decorators' do |app|
      config.to_prepare do
        Dir.glob(Rails.root.join('app/**/*_decorator*.rb')) do |path|
          require_dependency(path)
        end
      end
    end

    # Load application's view overrides
    initializer 'spree.overrides' do |app|
      config.to_prepare do
        Dir.glob(Rails.root.join('app/overrides/*.rb')) do |path|
          require_dependency(path)
        end
      end
    end

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Tokyo'
    config.generators.test_framework = :rspec
    config.generators.system_tests   = false
    config.generators.stylesheets    = false
    config.generators.javascripts    = false
    config.generators.helper         = false
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.i18n.default_locale = :ja
    config.i18n.fallbacks = [I18n.default_locale]
    Money.locale_backend = :i18n
  end
end
