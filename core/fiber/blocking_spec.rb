require_relative '../../spec_helper'

ruby_version_is "3.0" do
  require "fiber"

  describe "Fiber.blocking?" do
    context "when fiber is non-blocking" do
      it "returns false by default" do
        fiber = Fiber.new { Fiber.current.blocking? }
        blocking = fiber.resume

        blocking.should == false
      end

      it "returns false for blocking: false" do
        fiber = Fiber.new(blocking: false) { Fiber.current.blocking? }
        blocking = fiber.resume

        blocking.should == false
      end
    end

    context "when fiber is blocking" do
      it "returns true for blocking: true" do
        fiber = Fiber.new(blocking: true) { Fiber.current.blocking? }
        blocking = fiber.resume

        blocking.should == true
      end
    end
  end
end
