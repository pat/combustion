# frozen_string_literal: true

require "fileutils"
require "pathname"

class Combustion::Databases::SQLite < Combustion::Databases::Base
  private

  def create
    if exists?
      warn "#{config[:database]} already exists"
      return
    end

    establish_connection configuration
    connection
  rescue StandardError => error
    warn error, *error.backtrace
    warn "Couldn't create database for #{configuration.inspect}"
  end

  def drop
    FileUtils.rm_f file if exists?
  end

  def exists?
    File.exist? file
  end

  def file
    @file ||= path.absolute? ? path.to_s : File.join(Rails.root, path)
  end

  def path
    @path ||= Pathname.new configuration[:database]
  end
end
