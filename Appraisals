# frozen_string_literal: true

if RUBY_VERSION.to_f < 3.0
  appraise "rails-5.0" do
    gem "rails", "~> 5.0.2"
    gem "mysql2", "~> 0.4.4"
    gem "pg", "< 1.0"
  end

  appraise "rails-5.1" do
    gem "rails", "~> 5.1.0"
    gem "mysql2", "~> 0.4.4"
    gem "pg", "< 1.0"
  end

  appraise "rails-5.2" do
    gem "rails", "~> 5.2.0"
    gem "mysql2", "~> 0.5.0"
  end
end

if RUBY_VERSION.to_f >= 2.5 && RUBY_VERSION.to_f < 3.1
  appraise "rails-6.0" do
    gem "rails", "~> 6.0.0"
    gem "mysql2", "~> 0.5.0"
    gem "sqlite3", "~> 1.4", "< 1.5.0"
  end
end

if RUBY_VERSION.to_f >= 2.5
  appraise "rails-6.1" do
    gem "rails", "~> 6.1.0"
    gem "mysql2", "~> 0.5.0"
    gem "sqlite3", "~> 1.4", "< 1.6.0"
  end
end

if RUBY_VERSION.to_f >= 2.7
  appraise "rails-7.0" do
    gem "rails", "~> 7.0.1"
    gem "mysql2", "~> 0.5.0"
    gem "sqlite3", "~> 1.4"
  end

  appraise "rails-7.1" do
    gem "rails", "~> 7.1.2"
    gem "mysql2", "~> 0.5.0"
    gem "sqlite3", "~> 1.4"
  end
end

if RUBY_VERSION.to_f >= 3.1
  appraise "rails-edge" do
    gem "rails", :git => "https://github.com/rails/rails.git", :branch => "main"
    gem "mysql2", "~> 0.5.0"
    gem "sqlite3", "~> 1.4"
  end
end
