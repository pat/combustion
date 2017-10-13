# frozen_string_literal: true

require "rails"
require "active_support/dependencies"

module Combustion
  module Configurations
    #
  end

  mattr_accessor :path, :schema_format, :setup_environment

  self.path          = "/spec/internal"
  self.schema_format = :ruby

  MODULES = if Rails.version.to_f >= 3.1
    %w[ active_record action_controller action_view action_mailer sprockets ]
  else
    %w[ active_record action_controller action_view action_mailer ]
  end

  def self.initialize!(*modules, &block)
    self.setup_environment = block if block_given?

    options = modules.extract_options!
    modules = MODULES if modules == [:all]
    modules.each { |mod| require "#{mod}/railtie" }

    Bundler.require :default, Rails.env

    Combustion::Application.configure_for_combustion
    include_database modules, options
    Combustion::Application.initialize!
    include_rspec
  end

  def self.include_database(modules, options)
    return unless modules.map(&:to_s).include? "active_record"

    Combustion::Application.config.to_prepare do
      Combustion::Database.setup(options)
    end
  end

  def self.include_rspec
    return unless defined?(RSpec) && RSpec.respond_to?(:configure)

    RSpec.configure do |config|
      include_capybara_into config

      config.include Combustion::Application.routes.url_helpers
      if Combustion::Application.routes.respond_to?(:mounted_helpers)
        config.include Combustion::Application.routes.mounted_helpers
      end
    end
  end

  def self.include_capybara_into(config)
    return unless defined?(Capybara)

    config.include Capybara::RSpecMatchers if defined?(Capybara::RSpecMatchers)
    config.include Capybara::DSL           if defined?(Capybara::DSL)
    return if defined?(Capybara::RSpecMatchers) || defined?(Capybara::DSL)

    config.include Capybara
  end
end

require "combustion/application"
require "combustion/configurations/action_controller"
require "combustion/configurations/action_mailer"
require "combustion/configurations/active_record"
require "combustion/database"
