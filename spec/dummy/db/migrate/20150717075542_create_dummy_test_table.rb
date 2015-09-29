class CreateDummyTestTable < ActiveRecord::Migration
  def change
    create_table 'dummy_table'
  end
end
