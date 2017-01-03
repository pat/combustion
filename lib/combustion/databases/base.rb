require 'active_support/core_ext/module/delegation'

class Combustion::Databases::Base
  def initialize(configuration)
    @configuration = configuration
  end

  def reset
    drop
    create

    establish_connection(:test)
  end

  private

  attr_reader :configuration

  delegate :establish_connection, :connection, :to => :base

  def base
    ActiveRecord::Base
  end
end
