# frozen_string_literal: true

class Combustion::Database::Reset
  UnsupportedDatabase = Class.new StandardError

  OPERATOR_PATTERNS = {
    Combustion::Databases::MySQL => [/mysql/],
    Combustion::Databases::PostgreSQL => [/postgres/, /postgis/],
    Combustion::Databases::SQLite     => [/sqlite/],
    Combustion::Databases::SQLServer  => [/sqlserver/],
    Combustion::Databases::Oracle     => %w[ oci oracle ],
    Combustion::Databases::Firebird   => %w[ firebird ]
  }.freeze

  def self.call
    new.call
  end

  def initialize
    ActiveRecord::Base.configurations = YAML.safe_load(
      ERB.new(database_yaml).result, [], [], true
    )
  end

  def call
    ActiveRecord::Base.configurations.each_value do |configuration|
      adapter = configuration["adapter"] ||
                configuration["url"].split("://").first

      operator_class(adapter).new(configuration).reset
    end
  end

  private

  def database_yaml
    File.read "#{Rails.root}/config/database.yml"
  end

  def operator_class(adapter)
    klass = nil
    OPERATOR_PATTERNS.each do |operator, keys|
      klass = operator if keys.any? { |key| adapter[key] }
    end
    return klass if klass

    raise UnsupportedDatabase, "Unsupported database type: #{adapter}"
  end
end
