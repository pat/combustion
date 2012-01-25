class Combustion::Database
  def self.setup
    silence_stream(STDOUT) do
      reset_database
      load_schema
      migrate
    end
  end

  def self.reset_database
    abcs = ActiveRecord::Base.configurations
    case abcs['test']['adapter']
    when /mysql/
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.recreate_database(abcs['test']['database'],
        mysql_creation_options(abcs['test']))
      ActiveRecord::Base.establish_connection(:test)
    when /postgresql/
      ActiveRecord::Base.clear_active_connections!
      drop_database(abcs['test'])
      create_database(abcs['test'])
    when /sqlite/
      dbfile = abcs['test']['database'] || abcs['test']['dbfile']
      File.delete(dbfile) if File.exist?(dbfile)
    when 'sqlserver'
      test = abcs.deep_dup['test']
      test_database = test['database']
      test['database'] = 'master'
      ActiveRecord::Base.establish_connection(test)
      ActiveRecord::Base.connection.recreate_database!(test_database)
    when "oci", "oracle"
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.structure_drop.split(";\n\n").each do |ddl|
        ActiveRecord::Base.connection.execute(ddl)
      end
    when 'firebird'
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.recreate_database!
    else
      raise "Cannot reset databases for '#{abcs['test']['adapter']}'"
    end
  end

  def self.load_schema
    load "#{Rails.root}/db/schema.rb"
  end

  def self.migrate
    migrator = ActiveRecord::Migrator
    paths    = 'db/migrate/'

    if migrator.respond_to?(:migrations_paths)
      paths    = migrator.migrations_paths
    end

    migrator.migrate paths, nil
  end

  private

  def self.create_database(config)
    begin
      if config['adapter'] =~ /sqlite/
        if File.exist?(config['database'])
          $stderr.puts "#{config['database']} already exists"
        else
          begin
            # Create the SQLite database
            ActiveRecord::Base.establish_connection(config)
            ActiveRecord::Base.connection
          rescue Exception => e
            $stderr.puts e, *(e.backtrace)
            $stderr.puts "Couldn't create database for #{config.inspect}"
          end
        end
        return # Skip the else clause of begin/rescue
      else
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection
      end
    rescue
      case config['adapter']
      when /^(jdbc)?mysql/
        if config['adapter'] =~ /jdbc/
          #FIXME After Jdbcmysql gives this class
          require 'active_record/railties/jdbcmysql_error'
          error_class = ArJdbcMySQL::Error
        else
          error_class = config['adapter'] =~ /mysql2/ ? Mysql2::Error : Mysql::Error
        end
        access_denied_error = 1045
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], mysql_creation_options(config))
          ActiveRecord::Base.establish_connection(config)
        rescue error_class => sqlerr
          if sqlerr.errno == access_denied_error
            print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
            root_password = $stdin.gets.strip
            grant_statement = "GRANT ALL PRIVILEGES ON #{config['database']}.* " \
              "TO '#{config['username']}'@'localhost' " \
              "IDENTIFIED BY '#{config['password']}' WITH GRANT OPTION;"
            ActiveRecord::Base.establish_connection(config.merge(
                'database' => nil, 'username' => 'root', 'password' => root_password))
            ActiveRecord::Base.connection.create_database(config['database'], mysql_creation_options(config))
            ActiveRecord::Base.connection.execute grant_statement
            ActiveRecord::Base.establish_connection(config)
          else
            $stderr.puts sqlerr.error
            $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset}, collation: #{config['collation'] || @collation}"
            $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
          end
        end
      when /^(jdbc)?postgresql$/
        @encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
          ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
          ActiveRecord::Base.establish_connection(config)
        rescue Exception => e
          $stderr.puts e, *(e.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      end
    else
      $stderr.puts "#{config['database']} already exists"
    end
  end

  def self.drop_database(config)
    case config['adapter']
    when /^(jdbc)?mysql/
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection.drop_database config['database']
    when /^(jdbc)?sqlite/
      require 'pathname'
      path = Pathname.new(config['database'])
      file = path.absolute? ? path.to_s : File.join(Rails.root, path)

      FileUtils.rm(file)
    when /^(jdbc)?postgresql$/
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.drop_database config['database']
    end
  end

  def self.mysql_creation_options(config)
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'

    {
      :charset   => (config['charset']   || @charset),
      :collation => (config['collation'] || @collation)
    }
  end
end
