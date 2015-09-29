require 'spec_helper'
require File.expand_path("../dummy/lib/engine.rb", __FILE__)

module Combustion
  describe Database do
    before do
      Dir.chdir(File.expand_path('../dummy', __FILE__)) do
        Combustion.initialize! :active_record
      end
    end

    it 'run migration from dummy engine' do
      expect(ActiveRecord::Base.connection.table_exists?('dummy_table')).to eq true
    end
  end
end

