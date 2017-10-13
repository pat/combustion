# frozen_string_literal: true

module Combustion
  module Databases
    #
  end

  class Database
    def self.setup(options = {})
      Combustion::Database::Reset.call if options.fetch(:database_reset, true)
      Combustion::Database::LoadSchema.call if options.fetch(:load_schema, true)
      Combustion::Database::Migrate.call if options.fetch(:database_migrate, true)
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
