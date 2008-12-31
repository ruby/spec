require File.dirname(__FILE__) + '/../spec_helper'

describe "``" do
  it "should return the result of the executed sub-process" do
    ip = 'world'
    `echo disc #{ip}`.should == "disc world\n"
  end
end

describe "%x()" do
  # NOTE: Interpolation ? It's not consistant with %w for example.
  it "is the same (and also can interpolate with #)" do
    ip = 'world'
    %x(echo disc #{ip}).should == "disc world\n"
  end
end

describe "%X" do
  it "doesn't exist" do
    lambda { eval '%X(echo disc)' }.should raise_error(SyntaxError)
  end
end
