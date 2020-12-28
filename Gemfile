# frozen_string_literal: true

source "http://rubygems.org"

gemspec

if RUBY_VERSION.to_f < 3.0
  gem "sqlite3", "~> 1.3.13"
else
  gem "sqlite3", "~> 1.4"
end

if RUBY_VERSION.to_f < 2.3
  gem "i18n",     "< 1.6"
  gem "nio4r",    "< 2.4"
  gem "nokogiri", "< 1.10.3"
end

if RUBY_VERSION.to_f > 2.4
  gem "rubocop",           "~> 0.92"
  gem "rubocop-packaging", "~> 0.5"
end
