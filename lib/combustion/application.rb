# frozen_string_literal: true

require "securerandom"
require "digest"
Rails.env = ENV["RAILS_ENV"] || "test"

module Combustion
  class Application < Rails::Application
    # Core Settings
    config.cache_classes               = true
    config.consider_all_requests_local = true
    config.secret_token                = Digest::SHA1.hexdigest Time.now.to_s
    config.eager_load                  = Rails.env.production?

    if Rails.version.to_f >= 4.0
      config.secret_key_base = SecureRandom.hex
    else
      config.whiny_nils = true
    end

    # ActiveSupport Settings
    config.active_support.deprecation = :stderr

    # Some settings we're not sure if we want, so let's not load them by
    # default. Instead, wait for this method to be invoked (to get around
    # load-order complications).
    def self.configure_for_combustion
      config.root = File.expand_path File.join(Dir.pwd, Combustion.path)

      Combustion::Configurations::ActiveRecord.call config
      Combustion::Configurations::ActionController.call config
      Combustion::Configurations::ActionMailer.call config

      config.assets.enabled = true if defined?(Sprockets)
    end

    initializer(
      :load_customized_environment_for_combustion,
      :before => :load_environment_config,
      :group  => :all
    ) do
      next unless Combustion.setup_environment
      Combustion::Application.class_eval(&Combustion.setup_environment)
    end
  end
end
