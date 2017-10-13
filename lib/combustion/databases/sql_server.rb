# frozen_string_literal: true

class Combustion::Databases::SQLServer < Combustion::Databases::Base
  def reset
    establish_connection configuration.merge("database" => "master")
    connection.recreate_database! configuration["database"]
  end
end
