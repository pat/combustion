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

# Gems that are no longer part of stdlib:
gem "net-smtp" if RUBY_VERSION.to_f > 3.0
gem "ostruct" if RUBY_VERSION.to_f > 3.4
gem "stringio" if RUBY_VERSION.to_f > 3.1
