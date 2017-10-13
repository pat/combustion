# frozen_string_literal: true

class Combustion::Databases::MySQL < Combustion::Databases::Base
  ACCESS_DENIED_ERROR = 10_145

  def reset
    establish_connection(configuration.merge("database" => nil))

    super
  end

  private

  def charset
    configuration["charset"] || ENV["CHARSET"] || "utf8"
  end

  def charset_error
    return "" unless config["charset"]

    "(if you set the charset manually, make sure you have a matching collation)"
  end

  def collation
    configuration["collation"] || ENV["COLLATION"] || "utf8_unicode_ci"
  end

  def create
    connection.create_database configuration["database"], creation_options
    establish_connection configuration
  rescue error_class => error
    rescue_create_from error
  end

  def create_as_root(error)
    establish_connection configuration.merge(
      "database" => nil,
      "username" => "root",
      "password" => request_password(error)
    )

    connection.create_database config["database"], creation_options
    connection.execute grant_statement

    establish_connection configuration
  end

  def creation_options
    {:charset => charset, :collation => collation}
  end

  def drop
    connection.drop_database configuration["database"]
  end

  def error_class
    if configuration["adapter"][/jdbc/]
      # FIXME: After Jdbcmysql gives this class
      require "active_record/railties/jdbcmysql_error"
      ArJdbcMySQL::Error
    elsif config["adapter"][/mysql2/] && defined?(Mysql2)
      Mysql2::Error
    else
      Mysql::Error
    end
  end

  def grant_statement
    <<-SQL
GRANT ALL PRIVILEGES ON #{configuration["database"]}.*
TO '#{configuration["username"]}'@'localhost'
IDENTIFIED BY '#{configuration["password"]}' WITH GRANT OPTION;
    SQL
  end

  def request_password(error)
    print <<-TXT.strip
#{error.error}.
Please provide the root password for your mysql installation
>
    TXT

    $stdin.gets.strip
  end

  def rescue_create_from(error)
    if error.errno == ACCESS_DENIED_ERROR
      create_as_root(error)
      return
    end

    $stderr.puts <<-TXT
#{error.error}
Couldn't create database for #{config.inspect}, charset: #{charset}, collation: #{collation}
#{charset_error}
    TXT
  end
end
