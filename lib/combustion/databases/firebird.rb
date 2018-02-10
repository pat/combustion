# frozen_string_literal: true

class Combustion::Databases::Firebird < Combustion::Databases::Base
  def reset
    establish_connection Rails.env.to_sym
    connection.recreate_database!
  end
end
