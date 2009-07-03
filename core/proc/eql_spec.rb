require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Proc#eql?" do
    it "returns true if self and other are the same object" do
      p = proc { :foo }
      p.eql?(p.dup).should be_true
      
      p = Proc.new { :foo }
      p.eql?(p.dup).should be_true

      p = lambda { :foo }
      p.eql?(p.dup).should be_true
    end

    it "returns true if self and other are both procs with the same body" do
      body = proc { :foo }
      p = proc &body
      p2 = proc &body
      p.eql?(p2).should be_true
      
      body = lambda { :foo }
      p = proc &body
      p2 = proc &body
      p.eql?(p2).should be_true
    end

    it "returns true if self and other are both lambdas with the same body" do
      body = proc { :foo }
      p = lambda &body
      p2 = lambda &body
      p.eql?(p2).should be_true
      
      body = lambda { :foo }
      p = lambda &body
      p2 = lambda &body
      p.eql?(p2).should be_true
    end

    it "returns true if self and other are different kinds of procs but have the same body" do
      body = proc { :foo }
      p = lambda &body
      p2 = proc &body
      p.eql?(p2).should be_true
      
      body = lambda { :foo }
      p = proc &body
      p2 = lambda &body
      p.eql?(p2).should be_true
    end

    it "returns true if the bodies of self and other are identical but represented by different objects" do
      foo = proc    { :foo }
      foo2 = lambda { :foo }
      p = lambda &foo
      p2 = proc  &foo2
      p.eql?(p2).should be_true
    end

    it "returns false if other is not a Proc" do
      p = proc { :foo }
      p.eql?([]).should be_false
      
      p = Proc.new { :foo }
      p.eql?(Object.new).should be_false

      p = lambda { :foo }
      p.eql?(:foo).should be_false
    end

    it "returns false if self and other are both procs but have different bodies" do
      p = proc { :bar }
      p2 = proc { :foo }
      p.eql?(p2).should be_false
    end

    it "returns false if self and other are both lambdas but have different bodies" do
      p = lambda { :foo }
      p2 = lambda { :bar }
      p.eql?(p2).should be_false
    end

    it "returns false if self and other are different kinds of procs and have different bodies" do
      p = lambda { :foo }
      p2 = proc { :bar }
      p.eql?(p2).should be_false
      
      p = proc { :foo }
      p2 = lambda { :bar }
      p.eql?(p2).should be_false
    end
  end
end
