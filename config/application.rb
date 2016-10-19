require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StatsApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Allowed options: :sql, :ruby.
     config.sequel.schema_format = :sql

     # Whether to dump the schema after successful migrations.
     # Defaults to false in production and test, true otherwise.
     config.sequel.schema_dump = true

     # These override corresponding settings from the database config.
     config.sequel.max_connections = 16
     config.sequel.search_path = %w(mine public)

     # Configure whether database's rake tasks will be loaded or not.
     #
     # If passed a String or Symbol, this will replace the `db:` namespace for
     # the database's Rake tasks.
     #
     # ex: config.sequel.load_database_tasks = :sequel
     #     will results in `rake db:migrate` to become `rake sequel:migrate`
     #
     # Defaults to true
    #  config.sequel.load_database_tasks = false

     # This setting disabled the automatic connect after Rails init
    #  config.sequel.skip_connect = true

     # If you want to use a specific logger
    #  config.sequel.logger = MyLogger.new($stdout)
    config.sequel.after_connect = proc do
      Sequel::Model.plugin :timestamps, update_on_create: true
      Sequel::Model.plugin :after_initialize
      Sequel.extension :migration
    end
  end
end
