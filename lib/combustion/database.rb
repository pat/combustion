# frozen_string_literal: true

module Combustion
  module Databases
    #
  end

  class Database
    DEFAULT_OPTIONS = {
      :database_reset   => true,
      :load_schema      => true,
      :database_migrate => true
    }.freeze

    def self.setup(options = {})
      options = DEFAULT_OPTIONS.merge options

      Combustion::Database::Reset.call      if options[:database_reset]
      Combustion::Database::LoadSchema.call if options[:load_schema]
      Combustion::Database::Migrate.call    if options[:database_migrate]
    end
  end
end

require "combustion/databases/base"
require "combustion/databases/firebird"
require "combustion/databases/mysql"
require "combustion/databases/oracle"
require "combustion/databases/postgresql"
require "combustion/databases/sql_server"
require "combustion/databases/sqlite"

require "combustion/database/load_schema"
require "combustion/database/migrate"
require "combustion/database/reset"
