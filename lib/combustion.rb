require 'rails'
require 'active_support/dependencies'

module Combustion
  Modules = %w( active_record action_controller action_view action_mailer
    sprockets )

  def self.initialize!(*modules)
    modules = Modules if modules.empty? || modules == [:all]
    modules.each { |mod| require "#{mod}/railtie" }

    Combustion::Application.configure_for_combustion
    Combustion::Application.initialize!

    silence_stream(STDOUT) do
      load "#{Rails.root}/db/schema.rb"
    end

    RSpec.configure do |config|
      if defined?(Capybara::RSpecMatchers)
        config.include Capybara::RSpecMatchers, :type => :view
        config.include Capybara::RSpecMatchers, :type => :helper
        config.include Capybara::RSpecMatchers, :type => :mailer
        config.include Capybara::RSpecMatchers, :type => :controller
      end

      if defined?(Capybara::DSL)
        config.include Capybara::DSL, :type => :controller
      end

      unless defined?(Capybara::RSpecMatchers) || defined?(Capybara::DSL)
        if defined?(Capybara)
          config.include Capybara, :type => :request
          config.include Capybara, :type => :controller
        end
      end
      
      config.include(Combustion::Application.routes.url_helpers)
      config.include(Combustion::Application.routes.mounted_helpers)
    end if defined?(RSpec) && RSpec.respond_to?(:configure)
  end
end

require 'combustion/application'
require 'combustion/version'
