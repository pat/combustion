class Combustion::Databases::Firebird < Combustion::Databases::Base
  def reset
    establish_connection :test
    connection.recreate_database!
  end
end
