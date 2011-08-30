require 'rails'
require 'active_support/dependencies'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

module Combustion
  def self.initialize!
    Combustion::Application.initialize!

    silence_stream(STDOUT) do
      load "#{Rails.root}/db/schema.rb"
    end

    RSpec.configure do |config|
      config.include(Capybara) if defined?(Capybara)

      config.include(Combustion::Application.routes.url_helpers)
      config.include(Combustion::Application.routes.mounted_helpers)
    end if defined?(RSpec)
  end
end

require 'combustion/application'
require 'combustion/version'
