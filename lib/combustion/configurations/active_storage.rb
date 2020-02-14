# frozen_string_literal: true

class Combustion::Configurations::ActiveStorage
  def self.call(config)
    return unless defined?(ActiveStorage::Engine)

    config.active_storage.service = :test
  end
end
