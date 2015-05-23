require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BotsHeaven
  class Application < Rails::Application
    # Optional auto load path
    config.autoload_paths << Rails.root.join('lib')

    # TimeZone and Locale Setting.
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      # Use Slim for template engine.
      g.template_engine :slim

      # Use Rspec for test engine.
      g.test_framework :rspec
    end
  end
end
