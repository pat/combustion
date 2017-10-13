# frozen_string_literal: true

module Dummy
  class Engine < ::Rails::Engine
    initializer :dummy,  :before => :load_init_rb do |app|
      app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
    end
  end
end
