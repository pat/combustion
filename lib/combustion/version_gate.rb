# frozen_string_literal: true

require "rubygems"

module Combustion
  class VersionGate
    def self.call(name, *constraints)
      new(name).call(*constraints)
    end

    def initialize(name)
      @name = name
    end

    # Using matches_spec? instead of match? because the former returns true
    # even when the spec has an appropriate _pre-release_ version.
    def call(*constraints)
      return false if spec.nil?

      dependency(*constraints).matches_spec?(spec)
    end

    private

    attr_reader :name

    def dependency(*constraints)
      Gem::Dependency.new(name, *constraints)
    end

    def spec
      Gem.loaded_specs.fetch(name, nil)
    end
  end
end
