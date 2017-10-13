# frozen_string_literal: true

superclass = ActiveRecord::VERSION::MAJOR < 5 ?
  ActiveRecord::Migration : ActiveRecord::Migration[4.2]
class CreateDummyTestTable < superclass
  def change
    create_table "dummy_table"
  end
end
