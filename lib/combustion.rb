# frozen_string_literal: true

require "rails"
require "active_support/dependencies"

require "combustion/version_gate"

module Combustion
  module Configurations
  end

  mattr_accessor :path, :schema_format, :setup_environment

  self.path          = "/spec/internal"
  self.schema_format = :ruby

  MODULES = {
    :active_model      => "active_model/railtie",
    :active_record     => "active_record/railtie",
    :action_controller => "action_controller/railtie",
    :action_mailer     => "action_mailer/railtie",
    :action_view       => "action_view/railtie",
    :sprockets         => "sprockets/railtie",
    :active_job        => "active_job/railtie",
    :action_cable      => "action_cable/engine",
    :active_storage    => "active_storage/engine",
    :action_text       => "action_text/engine",
    :action_mailbox    => "action_mailbox/engine"
  }.freeze

  AVAILABLE_MODULES = begin
    keys = MODULES.keys
    rails_gate = VersionGate.new("rails")

    keys.delete(:sprockets) unless rails_gate.call(">= 3.1", "< 7.0")
    keys.delete(:active_job) unless rails_gate.call(">= 4.2")
    keys.delete(:action_cable) unless rails_gate.call(">= 5.0")
    keys.delete(:active_storage) unless rails_gate.call(">= 5.2")
    keys.delete(:action_text) unless rails_gate.call(">= 6.0")
    keys.delete(:action_mailbox) unless rails_gate.call(">= 6.0")

    keys
  end.freeze

  def self.initialize!(*modules, &block)
    self.setup_environment = block if block_given?

    options = modules.extract_options!
    modules = AVAILABLE_MODULES if modules == [:all]
    modules.each { |mod| require MODULES.fetch(mod, "#{mod}/railtie") }

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

require "combustion/configurations/action_controller"
require "combustion/configurations/action_mailer"
require "combustion/configurations/active_record"
require "combustion/configurations/active_storage"
require "combustion/application"
require "combustion/database"
