class Combustion::Databases::MySQL < Combustion::Databases::Base
  ACCESS_DENIED_ERROR = 10145

  def reset
    establish_connection(configuration.merge('database' => nil))

    super
  end

  private

  def charset
    configuration['charset'] || ENV['CHARSET'] || 'utf8'
  end

  def collation
    configuration['collation'] || ENV['COLLATION'] || 'utf8_unicode_ci'
  end

  def create
    connection.create_database configuration['database'], creation_options
    establish_connection configuration
  rescue error_class => error
    if error.errno == ACCESS_DENIED_ERROR
      create_as_root
    else
      $stderr.puts error.error
      $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{charset}, collation: #{collation}"
      $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
    end
  end

  def create_as_root
    print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
    root_password = $stdin.gets.strip
    establish_connection configuration.merge(
      'database' => nil, 'username' => 'root', 'password' => root_password
    )
    connection.create_database config['database'], creation_options
    connection.execute grant_statement
    establish_connection configuration
  end

  def creation_options
    {:charset => charset, :collation => collation}
  end

  def drop
    connection.drop_database configuration['database']
  end

  def error_class
    if configuration['adapter'] =~ /jdbc/
      #FIXME After Jdbcmysql gives this class
      require 'active_record/railties/jdbcmysql_error'
      error_class = ArJdbcMySQL::Error
    else
      error_class = config['adapter'] =~ /mysql2/ && defined?(Mysql2) ? Mysql2::Error : Mysql::Error
    end
  end

  def grant_statement
    <<-SQL
GRANT ALL PRIVILEGES ON #{configuration['database']}.*
TO '#{configuration['username']}'@'localhost'
IDENTIFIED BY '#{configuration['password']}' WITH GRANT OPTION;
    SQL
  end
end
