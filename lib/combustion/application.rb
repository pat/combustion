# frozen_string_literal: true

require 'securerandom'
Rails.env = ENV['RAILS_ENV'] || 'test'

module Combustion
  class Application < Rails::Application
    # Core Settings
    config.cache_classes               = true
    config.whiny_nils                  = true if Rails.version.to_s < '4.0.0'
    config.consider_all_requests_local = true
    config.secret_token                = Digest::SHA1.hexdigest Time.now.to_s
    config.eager_load                  = Rails.env.production?
    config.secret_key_base             = SecureRandom.hex if Rails.version.to_s >= '4.0.0'

    # ActiveSupport Settings
    config.active_support.deprecation = :stderr

    # Some settings we're not sure if we want, so let's not load them by
    # default. Instead, wait for this method to be invoked (to get around
    # load-order complications).
    def self.configure_for_combustion
      config.root = File.expand_path File.join(Dir.pwd, Combustion.path)

      if defined?(ActiveRecord::Railtie) && ::ActiveRecord.constants.include?(:MassAssignmentSecurity)
        # Turn on ActiveRecord attribute whitelisting
        # This way the dummy app matches new rails apps re: this setting
        config.active_record.whitelist_attributes      = true
        config.active_record.mass_assignment_sanitizer = :strict
      end

      if defined?(ActionController::Railtie)
        config.action_dispatch.show_exceptions            = false
        config.action_controller.perform_caching          = false
        config.action_controller.allow_forgery_protection = false
      end

      if defined?(ActionMailer::Railtie)
        config.action_mailer.delivery_method     = :test
        config.action_mailer.default_url_options = {:host => 'www.example.com'}
      end

      if defined?(Sprockets)
        config.assets.enabled = true
      end
    end

    initializer :load_customized_environment_for_combustion, :before => :load_environment_config, :group => :all do
      Combustion::Application.class_eval(&Combustion.setup_environment) if Combustion.setup_environment
    end
  end
end
