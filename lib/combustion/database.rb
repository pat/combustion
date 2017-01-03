module Combustion
  module Databases
    #
  end

  class Database
    def self.setup
      Combustion::Database::Reset.call
      Combustion::Database::LoadSchema.call
      Combustion::Database::Migrate.call
    end
  end
end

require 'combustion/database/load_schema'
require 'combustion/database/migrate'
require 'combustion/database/reset'

require 'combustion/databases/base'
require 'combustion/databases/firebird'
require 'combustion/databases/mysql'
require 'combustion/databases/oracle'
require 'combustion/databases/postgresql'
require 'combustion/databases/sql_server'
require 'combustion/databases/sqlite'
