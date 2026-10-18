# frozen_string_literal: true

RSpec.describe Combustion do
  describe ".include_database" do
    # Rails 8.2 makes reloader callbacks Ractor-shareable when
    # ActiveSupport::Ractors.unshareable_proc_action is set, which needs every
    # value the block refers to to be shareable.
    it "registers a prepare block that can be made Ractor-shareable" do
      unless defined?(Ractor) && Ractor.respond_to?(:make_shareable)
        skip "needs Ractor.make_shareable"
      end

      block = nil
      allow(Combustion::Application.config).
        to receive(:to_prepare) { |&hook| block = hook }

      Combustion.include_database [:active_record], :database_reset => false

      expect { Ractor.make_shareable(block) }.not_to raise_error
    end
  end
end
