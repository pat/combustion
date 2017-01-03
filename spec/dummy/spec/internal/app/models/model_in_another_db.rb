class ModelInAnotherDb < ActiveRecord::Base
  self.table_name = 'dummy_in_another_db'

  establish_connection :test_another
end
