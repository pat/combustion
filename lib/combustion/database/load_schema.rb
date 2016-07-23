class Combustion::Database::LoadSchema
  UnknownSchemaFormat = Class.new StandardError

  def self.call
    new.call
  end

  def call
    case schema_format
    when :ruby
      load Rails.root.join('db', 'schema.rb')
    when :sql
      ActiveRecord::Base.connection.execute(
        File.read(Rails.root.join('db', 'structure.sql'))
      )
    else
      raise UnknownSchemaFormat, "Unknown schema format: #{schema_format}"
    end
  end

  private

  def schema_format
    Combustion.schema_format
  end
end
