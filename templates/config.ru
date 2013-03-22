require 'rubygems'
require 'bundler'

Bundler.require :default, :development

COMBUSTION_SEED = true
Combustion.initialize!
run Combustion::Application
