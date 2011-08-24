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
  end
end

require 'combustion/application'
require 'combustion/version'
