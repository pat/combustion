# frozen_string_literal: true

require "combustion"

if Combustion::VersionGate.call("rails", "< 4.1")
  require "active_record"
  require "active_record/connection_adapters/mysql2_adapter"

  class ActiveRecord::ConnectionAdapters::Mysql2Adapter
    NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
  end
end

require File.expand_path("dummy/lib/engine.rb", __dir__)

Dir.chdir(File.expand_path("dummy", __dir__)) do
  Combustion.initialize! :all
end
