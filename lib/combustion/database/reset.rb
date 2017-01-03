class Combustion::Database::Reset
  UnsupportedDatabase = Class.new StandardError

  def self.call
    new.call
  end

  def initialize
    ActiveRecord::Base.configurations = YAML.load(
      ERB.new(File.read("#{Rails.root}/config/database.yml")).result
    )
  end

  def call
    ActiveRecord::Base.configurations.values.each do |conf|
      operator_class(conf['adapter']).new(conf).reset
    end
  end

  private

  def operator_class(adapter)
    @operator ||= case adapter
    when /mysql/
      Combustion::Databases::MySQL
    when /postgresql/, /postgis/
      Combustion::Databases::PostgreSQL
    when /sqlite/
      Combustion::Databases::SQLite
    when /sqlserver/
      Combustion::Databases::SQLServer
    when 'oci', 'oracle'
      Combustion::Databases::Oracle
    when 'firebird'
      Combustion::Databases::Firebird
    else
      raise UnsupportedDatabase,
        "Unsupported database type: #{adapter}"
    end
  end
end
