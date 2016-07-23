class Combustion::Databases::PostgreSQL < Combustion::Databases::Base
  def reset
    base.clear_active_connections!

    super
  end

  private

  def create
    establish_connection postgres_configuration
    connection.create_database configuration['database'],
      configuration.merge('encoding' => encoding)
    establish_connection configuration
  rescue Exception => error
    $stderr.puts error, *(error.backtrace)
    $stderr.puts "Couldn't create database for #{configuration.inspect}"
  end

  def drop
    establish_connection postgres_configuration
    connection.drop_database configuration['database']
  end

  def encoding
    configuration['encoding'] || ENV['CHARSET'] || 'utf8'
  end

  def postgres_configuration
    configuration.merge(
      'database'           => 'postgres',
      'schema_search_path' => 'public'
    )
  end
end
