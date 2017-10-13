# frozen_string_literal: true

require "thor/group"

module Combustion
  class Generator < Thor::Group
    include Thor::Actions

    def self.source_root
      File.expand_path File.join(File.dirname(__FILE__), "..", "..")
    end

    def create_directories
      empty_directory "spec/internal"
      empty_directory "spec/internal/config"
      empty_directory "spec/internal/db"
      empty_directory "spec/internal/log"
      empty_directory "spec/internal/public"
    end

    def create_files
      template "templates/routes.rb",    "spec/internal/config/routes.rb"
      template "templates/database.yml", "spec/internal/config/database.yml"
      template "templates/schema.rb",    "spec/internal/db/schema.rb"
      template "templates/config.ru",    "config.ru"
      create_file                        "spec/internal/public/favicon.ico"
      create_file                        "spec/internal/log/.gitignore" do
        "*.log"
      end
    end
  end
end
