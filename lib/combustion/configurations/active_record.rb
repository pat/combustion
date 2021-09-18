# frozen_string_literal: true

class Combustion::Configurations::ActiveRecord
  def self.call(config)
    if ActiveRecord::VERSION::MAJOR >= 7
      config.active_record.legacy_connection_handling = false
    end

    return unless defined?(ActiveRecord::Railtie)
    return unless ::ActiveRecord.constants.include?(:MassAssignmentSecurity)

    # Turn on ActiveRecord attribute whitelisting
    # This way the dummy app matches new rails apps re: this setting
    config.active_record.whitelist_attributes      = true
    config.active_record.mass_assignment_sanitizer = :strict
  end
end
