Rails.env = 'test'

class Combustion::Application < Rails::Application
  # Core Settings
  config.cache_classes               = true
  config.whiny_nils                  = true
  config.consider_all_requests_local = true
  config.secret_token                = Digest::SHA1.hexdigest Time.now.to_s

  # ActiveSupport Settings
  config.active_support.deprecation = :stderr

  # Some settings we're not sure if we want, so let's not load them by default.
  # Instead, wait for this method to be invoked (to get around load-order
  # complications).
  def self.configure_for_combustion
    config.root = File.expand_path File.join(Dir.pwd, Combustion.path)

    if defined?(ActionController) && defined?(ActionController::Railtie)
      config.action_dispatch.show_exceptions            = false
      config.action_controller.perform_caching          = false
      config.action_controller.allow_forgery_protection = false
    end

    if defined?(ActionMailer) && defined?(ActionMailer::Railtie)
      config.action_mailer.delivery_method     = :test
      config.action_mailer.default_url_options = {:host => 'www.example.com'}
    end

    if defined?(Sprockets)
      config.assets.enabled = true
    end
  end
end
