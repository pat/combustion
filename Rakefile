# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

Rake::Task["default"].clear if Rake::Task.task_defined?("default")
task :default => %i[ rubocop spec ]
