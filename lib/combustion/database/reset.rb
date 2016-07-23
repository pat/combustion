class Combustion::Database::Reset
  UnsupportedDatabase = Class.new StandardError

  def self.call(adapter = nil)
    new(adapter).call
  end

  def initialize(adapter = nil)
    @adapter = adapter

    set_configurations
  end

  def call
    operator.reset
  end

  private

  def configuration
    @configuration ||= ActiveRecord::Base.configurations['test']
  end

  def operator
    operator_class.new configuration
  end

  def operator_class
    @operator ||= case configuration['adapter']
    when /mysql/
      Combustion::Databases::MySQL
    when /postgresql/
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
        "Unsupported database type: #{configuration['adapter']}"
    end
  end

  def set_configurations
    ActiveRecord::Base.configurations = YAML.load(
      ERB.new(File.read("#{Rails.root}/config/database.yml")).result
    )
  end
end
