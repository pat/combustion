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
    ActiveRecord::Migrator.migrate ActiveRecord::Migrator.migrations_paths, nil
  end
end
