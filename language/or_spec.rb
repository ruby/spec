require_relative '../spec_helper'

describe "The || operator" do
  it "evaluates to true if any of its operands are true" do
    if false || true || nil
      x = true
    end
    x.should == true
  end

  it "evaluated to false if all of its operands are false" do
    if false || nil
      x = true
    end
    x.should == nil
  end

  it "is evaluated before assignment operators" do
    x = nil || true
    x.should == true
  end

  it "has a lower precedence than the && operator" do
    x = 1 || false && x = 2
    x.should == 1
  end

  it "treats empty expressions as nil" do
    (() || true).should == true
    (() || false).should == false
    (true || ()).should == true
    (false || ()).should == nil
    (() || ()).should == nil
  end

  it "has a higher precedence than 'break' in 'break true || false'" do
    # see also 'break true or false' below
    -> { break false || true }.call.should == true
  end

  it "has a higher precedence than 'next' in 'next true || false'" do
    -> { next false || true }.call.should == true
  end

  it "has a higher precedence than 'return' in 'return true || false'" do
    -> { return false || true }.call.should == true
  end

  ruby_version_is "4.0" do
    it "continues the previous line when it begins the next line" do
      code = <<~CODE
        false
          || 2
        CODE

      eval(code).should == 2
    end

    it "short-circuits when it begins the next line" do
      code = <<~CODE
        x = nil
        1
          || (x = 2)
        x
        CODE

      eval(code).should == nil
    end
  end
end

describe "The or operator" do
  it "evaluates to true if any of its operands are true" do
    x = nil
    if false or true
      x = true
    end
    x.should == true
  end

  it "is evaluated after variables are assigned" do
    x = nil or true
    x.should == nil
  end

  it "has a lower precedence than the || operator" do
    x,y = nil
    x = true || false or y = 1
    y.should == nil
  end

  it "treats empty expressions as nil" do
    (() or true).should == true
    (() or false).should == false
    (true or ()).should == true
    (false or ()).should == nil
    (() or ()).should == nil
  end

  it "has a lower precedence than 'break' in 'break true or false'" do
    # see also 'break true || false' above
    -> { eval "break true or false" }.should.raise(SyntaxError, /void value expression/)
  end

  it "has a lower precedence than 'next' in 'next true or false'" do
    -> { eval "next true or false" }.should.raise(SyntaxError, /void value expression/)
  end

  it "has a lower precedence than 'return' in 'return true or false'" do
    -> { eval "return true or false" }.should.raise(SyntaxError, /void value expression/)
  end

  ruby_version_is "4.0" do
    it "continues the previous line when it begins the next line" do
      code = <<~CODE
        false
          or 2
        CODE

      eval(code).should == 2
    end

    it "short-circuits when it begins the next line" do
      code = <<~CODE
        x = nil
        1
          or (x = 2)
        x
        CODE

      eval(code).should == nil
    end
  end
end
