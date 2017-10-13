# frozen_string_literal: true

class Combustion::Database::LoadSchema
  UnknownSchemaFormat = Class.new StandardError

  def self.call
    new.call
  end

  def call
    ActiveRecord::Schema.verbose = false

    case schema_format
    when :ruby
      load_ruby_schema
    when :sql
      load_sql_schema
    else
      raise UnknownSchemaFormat, "Unknown schema format: #{schema_format}"
    end
  end

  private

  def load_ruby_schema
    load Rails.root.join("db", "schema.rb")
  end

  def load_sql_schema
    ActiveRecord::Base.connection.execute(
      File.read(Rails.root.join("db", "structure.sql"))
    )
  end

  def schema_format
    Combustion.schema_format
  end
end
