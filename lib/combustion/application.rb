# frozen_string_literal: true

require "securerandom"
require "digest"
Rails.env = ENV["RAILS_ENV"] || "test"

module Combustion
  class Application < Rails::Application
    CONFIGURERS = [
      Combustion::Configurations::ActiveRecord,
      Combustion::Configurations::ActionController,
      Combustion::Configurations::ActionMailer,
      Combustion::Configurations::ActiveStorage
    ].freeze

    rails_gate = VersionGate.new("rails")

    # Core Settings
    config.cache_classes               = true
    config.consider_all_requests_local = true
    config.eager_load                  = Rails.env.production?

    config.secret_key_base = SecureRandom.hex if rails_gate.call(">= 4.0")
    config.whiny_nils      = true             if rails_gate.call("< 4")
    if rails_gate.call("< 5.2")
      config.secret_token = Digest::SHA1.hexdigest Time.now.to_s
    end

    # ActiveSupport Settings
    config.active_support.deprecation = :stderr

    # Some settings we're not sure if we want, so let's not load them by
    # default. Instead, wait for this method to be invoked (to get around
    # load-order complications).
    def self.configure_for_combustion
      config.root = File.expand_path File.join(Dir.pwd, Combustion.path)

      CONFIGURERS.each { |configurer| configurer.call config }

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
