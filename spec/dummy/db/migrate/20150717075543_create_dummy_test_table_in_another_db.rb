class CreateDummyTestTableInAnotherDb < ActiveRecord::Migration
  def change
    create_table 'dummy_in_another_db'
  end

  def connection
    ModelInAnotherDb.connection
  end
end
