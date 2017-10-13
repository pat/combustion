# frozen_string_literal: true

class Combustion::Configurations::ActionMailer
  def self.call(config)
    return unless defined?(ActionMailer::Railtie)

    config.action_mailer.delivery_method     = :test
    config.action_mailer.default_url_options = {:host => "www.example.com"}
  end
end
