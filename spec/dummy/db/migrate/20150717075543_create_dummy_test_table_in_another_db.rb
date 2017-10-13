# frozen_string_literal: true

superclass = ActiveRecord::VERSION::MAJOR < 5 ?
  ActiveRecord::Migration : ActiveRecord::Migration[4.2]
class CreateDummyTestTableInAnotherDb < superclass
  def change
    create_table "dummy_in_another_db"
  end

  def connection
    ModelInAnotherDb.connection
  end
end
