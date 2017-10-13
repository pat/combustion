# frozen_string_literal: true

require "bundler/setup"
require "combustion"

if Rails::VERSION::STRING.to_f < 4.1
  require "active_record"
  require "active_record/connection_adapters/mysql2_adapter"

  class ActiveRecord::ConnectionAdapters::Mysql2Adapter
    NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
  end
end

require File.expand_path("../dummy/lib/engine.rb", __FILE__)
