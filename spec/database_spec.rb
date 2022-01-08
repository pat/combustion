# frozen_string_literal: true

RSpec.describe Combustion::Database do
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
    if ActiveRecord::VERSION::STRING.to_f > 6.0
      expect(Model.connection_db_config.database).to match(/combustion/)
    else
      expect(Model.connection_config[:database]).to match(/combustion/)
    end
  end

  it "returns test_another for model with connection to second database" do
    if ActiveRecord::VERSION::STRING.to_f > 6.0
      expect(ModelInAnotherDb.connection_db_config.database).
        to match(/test_another/)
    else
      expect(ModelInAnotherDb.connection_config[:database]).
        to match(/test_another/)
    end
  end
end
