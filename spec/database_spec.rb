# frozen_string_literal: true

module Combustion
  describe Database do
    before(:all) do
      Dir.chdir(File.expand_path("../dummy", __FILE__)) do
        Combustion.initialize! :active_record
      end
    end

    it "creates dummy table from migration in base database" do
      expect(Model.connection.table_exists?("dummy_table")).to eq true
      expect(Model.connection.table_exists?("dummy_in_another_db")).to eq false
    end

    it "creates another dummy table from another database" do
      expect(ModelInAnotherDb.connection.table_exists?("dummy_table")).
        to eq false
      expect(ModelInAnotherDb.connection.table_exists?("dummy_in_another_db")).
        to eq true
    end

    it "returns test database for model with default connection" do
      expect(Model.connection_config[:database]).to match(/test/)
    end

    it "returns test_another for model with connection to second database" do
      expect(ModelInAnotherDb.connection_config[:database]).
        to match(/test_another/)
    end
  end
end
