# frozen_string_literal: true

source "http://rubygems.org"

gemspec

if RUBY_VERSION.to_f < 3.0
  gem "sqlite3", "~> 1.3.13"
else
  gem "sqlite3", "~> 1.4"
end

gem "rubocop",           "~> 0.92"
gem "rubocop-packaging", "~> 0.5"

# Required for testing Rails 6.1 on MRI 3.1+
gem "net-smtp" if RUBY_VERSION.to_f > 3.0
