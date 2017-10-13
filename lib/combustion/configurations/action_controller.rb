# frozen_string_literal: true

class Combustion::Configurations::ActionController
  def self.call(config)
    return unless defined?(ActionController::Railtie)

    config.action_dispatch.show_exceptions            = false
    config.action_controller.perform_caching          = false
    config.action_controller.allow_forgery_protection = false
  end
end
