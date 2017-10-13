# frozen_string_literal: true

class Combustion::Databases::Oracle < Combustion::Databases::Base
  def reset
    establish_connection :test
    connection.structure_drop.split(";\n\n").each do |ddl|
      connection.execute(ddl)
    end
  end
end
