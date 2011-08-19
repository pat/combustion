Rails.env = 'test'

class Combustion::Application < Rails::Application
  config.root   = File.expand_path File.join(Dir.pwd, 'spec', 'internal')

  # Core Settings
  config.cache_classes               = true
  config.whiny_nils                  = true
  config.consider_all_requests_local = true
  config.secret_token                = Digest::SHA1.hexdigest Time.now.to_s

  # ActiveSupport Settings
  config.active_support.deprecation = :stderr

  # Action Controller and Action Dispatch
  config.action_dispatch.show_exceptions            = false
  config.action_controller.perform_caching          = false
  config.action_controller.allow_forgery_protection = false

  # Action Mailer Settings
  # config.action_mailer.delivery_method      = :test
  # config.action_mailer.default_url_options  = {:host => 'www.example.com'}

  # Asset Settings
  config.assets.enabled = true
end
