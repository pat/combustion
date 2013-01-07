require 'rails'
require 'active_support/dependencies'

module Combustion
  mattr_accessor :path, :schema_format

  self.path          = '/spec/internal'
  self.schema_format = :ruby

  if Rails.version > '3.1'
    Modules = %w( active_record action_controller action_view action_mailer
      sprockets )
  else
    Modules = %w( active_record action_controller action_view action_mailer )
  end

  def self.initialize!(*modules)
    modules = Modules if modules == [:all]
    modules.each { |mod| require "#{mod}/railtie" }

    Combustion::Application.configure_for_combustion
    Combustion::Application.initialize!

    if modules.map(&:to_s).include? 'active_record'
      Combustion::Database.setup
    end

    RSpec.configure do |config|
      include_capybara_into config

      config.include Combustion::Application.routes.url_helpers
      if Combustion::Application.routes.respond_to?(:mounted_helpers)
        config.include Combustion::Application.routes.mounted_helpers
      end
    end if defined?(RSpec) && RSpec.respond_to?(:configure)
  end

  def self.include_capybara_into(config)
    return unless defined?(Capybara)

    config.include Capybara::RSpecMatchers if defined?(Capybara::RSpecMatchers)
    config.include Capybara::DSL           if defined?(Capybara::DSL)

    unless defined?(Capybara::RSpecMatchers) || defined?(Capybara::DSL)
      config.include Capybara
    end
  end
end

require 'combustion/application'
require 'combustion/database'
