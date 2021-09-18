# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "combustion"
  s.version     = "1.3.2"
  s.authors     = ["Pat Allan"]
  s.email       = ["pat@freelancing-gods.com"]
  s.homepage    = "https://github.com/pat/combustion"
  s.summary     = "Elegant Rails Engine Testing"
  s.description = "Test your Rails Engines without needing a full Rails app"
  s.license     = "MIT"

  s.files         = Dir["{exe,lib,templates}/**/*"] + %w[LICENCE README.md]
  s.test_files    =
    Dir["spec/**/*"] +
    %w[.rspec Appraisals Gemfile Rakefile] -
    %w[
      spec/dummy/spec/internal/log/development.log
      spec/dummy/spec/internal/log/test.log
      spec/dummy/spec/internal/test
      spec/dummy/spec/internal/test_another
    ]
  s.executables   = ["combust"]
  s.bindir        = "exe"
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activesupport", ">= 3.0.0"
  s.add_runtime_dependency "railties", ">= 3.0.0"
  s.add_runtime_dependency "thor",  ">= 0.14.6"

  s.add_development_dependency "appraisal", "~> 2.3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rails"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rubocop", "~> 0.81.0"
  s.add_development_dependency "sqlite3"
end
