require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Fiber#resume" do

    it "passes control to the beginning of the block on first invocation" do
      invoked = false
      fiber = Fiber.new { invoked = true }
      fiber.resume
      invoked.should be_true
    end

    it "returns the last value encountered on first invocation" do
      fiber = Fiber.new { false; true }
      fiber.resume.should be_true
    end

    it "runs until the end of the block or Fiber.yield on first invocation" do
      obj = mock('obj')
      obj.should_receive(:do).once 
      fiber = Fiber.new { 1 + 2; a = "glark"; obj.do }
      fiber.resume

      obj = mock('obj')
      obj.should_not_receive(:do)
      fiber = Fiber.new { 1 + 2; Fiber.yield; obj.do }
      fiber.resume
    end
    
    it "resumes from the last call to Fiber.yield on subsequent invocations" do
      fiber = Fiber.new { Fiber.yield :first; :second }
      fiber.resume.should == :first
      fiber.resume.should == :second
    end  

    it "accepts any number of arguments" do
      fiber = Fiber.new { |a| }
      lambda { fiber.resume(*(1..10).to_a) }.should_not raise_error
    end

    it "sets the block parameters to its arguments on the first invocation" do
      first = mock('first')
      first.should_receive(:arg).with(:first).twice
      fiber = Fiber.new { |arg| first.arg arg; Fiber.yield; first.arg arg; }
      fiber.resume :first
      fiber.resume :second
    end

    it "raises a FiberError if the Fiber is dead" do
      fiber = Fiber.new { true }
      fiber.resume
      lambda { fiber.resume }.should raise_error(FiberError)
    end

  end
end
