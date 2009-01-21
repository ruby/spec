require File.dirname(__FILE__) + '/../spec_helper'

describe "A method call" do
  before :each do
    @obj = Object.new
    def @obj.foo(a, b, &c)
      [a, b, c ? c.call : nil]
    end
  end

  it "evaluates the receiver first" do
    (obj = @obj).foo(obj = nil, obj = nil).should == [nil, nil, nil]
  end

  it "evaluates arguments after receiver" do
    a = 0
    (a += 1; @obj).foo(a, a).should == [1, 1, nil]
    a.should == 1
  end

  it "evaluates arguments left-to-right" do
    a = 0
    @obj.foo(a += 1, a += 1).should == [1, 2, nil]
    a.should == 2
  end

  ruby_bug "redmine #1034", "1.8" do
    it "evaluates block pass after arguments" do
      a = 0
      p = proc {true}
      @obj.foo(a += 1, a += 1, &(a += 1; p)).should == [1, 2, true]
      a.should == 3
    end
 
    it "evaluates block pass after receiver" do
      p1 = proc {true}
      p2 = proc {false}
      p1.should_not == p2
  
      p = p1
      (p = p2; @obj).foo(1, 1, &p).should == [1, 1, false]
    end
  end
end
