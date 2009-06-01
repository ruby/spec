require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Fiber#transfer" do
    
    require 'fiber'
    
    it "passes control to the beginning of the block on first invocation" do
      invoked = false
      fiber = Fiber.new { invoked = true }
      fiber.transfer
      invoked.should be_true
    end

    it "returns the last value encountered on first invocation" do
      fiber = Fiber.new { false; true }
      fiber.transfer.should be_true
    end

    it "runs until the end of the block or Fiber.yield on first invocation" do
      obj = mock('obj')
      obj.should_receive(:do).once 
      fiber = Fiber.new { 1 + 2; a = "glark"; obj.do }
      fiber.transfer

      obj = mock('obj')
      obj.should_not_receive(:do)
      fiber = Fiber.new { 1 + 2; Fiber.yield; obj.do }
      fiber.transfer
    end
    
    it "resumes from the last call to Fiber.yield on subsequent invocations" do
      fiber = Fiber.new { Fiber.yield :first; :second }
      fiber.transfer.should == :first
      fiber.transfer.should == :second
    end  

    it "accepts any number of arguments" do
      fiber = Fiber.new { |a| }
      lambda { fiber.transfer(*(1..10).to_a) }.should_not raise_error
    end

    it "sets the block parameters to its arguments on the first invocation" do
      first = mock('first')
      first.should_receive(:arg).with(:first).twice
      fiber = Fiber.new { |arg| first.arg arg; Fiber.yield; first.arg arg; }
      fiber.transfer :first
      fiber.transfer :second
    end

    it "raises a FiberError if the Fiber is dead" do
      fiber = Fiber.new { true }
      fiber.transfer
      lambda { fiber.transfer }.should raise_error(FiberError)
    end

    it "raises a FiberError if the Fiber has transfered control to another Fiber" do
      fiber1 = Fiber.new { true }
      fiber2 = Fiber.new { fiber1.transfer }
      fiber2.resume
      lambda { fiber2.resume }.should raise_error(FiberError)
    end

    it "raises a LocalJumpError if the block includes a return statement" do
      fiber = Fiber.new { return; }
      lambda { fiber.resume }.should raise_error(LocalJumpError)
    end 

    it "raises a LocalJumpError if the block includes a break statement" do
      fiber = Fiber.new { break; }
      lambda { fiber.resume }.should raise_error(LocalJumpError)
    end 
    it "transfers control from one Fiber to another when called from a Fiber" do
      fiber1 = Fiber.new { :fiber1 }
      fiber2 = Fiber.new { fiber1.transfer }
      fiber2.resume.should == :fiber1
    end

    it "can be invoked from the root Fiber" do
     fiber = Fiber.new { :fiber }
     fiber.transfer.should == :fiber
    end

    it "can be invoked from the same Fiber it transfers control to" do
      states = []
      fiber = Fiber.new { states << :start; fiber.transfer; states << :end } 
      fiber.transfer
      states.should == [:start, :end]

      states = []
      fiber = Fiber.new { states << :start; fiber.transfer; states << :end } 
      fiber.resume
      states.should == [:start, :end]
    end    

    it "can transfer control to a Fiber that has transfered to another Fiber" do
      states = []
      fiber1 = Fiber.new { states << :fiber1 }
      fiber2 = Fiber.new { states << :fiber2_start; fiber1.transfer; states << :fiber2_end}
      fiber2.resume.should == [:fiber2_start, :fiber1]
      fiber2.transfer.should == [:fiber2_start, :fiber1, :fiber2_end]
    end

    ruby_bug "#1548", "1.9.2" do
      it "raises a FiberError when transferring to a Fiber which resumes itself" do
        fiber = Fiber.new { fiber.resume }
        lambda { fiber.transfer }.should raise_error(FiberError)
      end
    end  
  end
end
