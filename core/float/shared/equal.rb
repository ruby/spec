describe :float_equal, :shared => true do
  it "returns true if self has the same value as other" do
    1.0.send(@method, 1).should == true
    2.71828.send(@method, 1.428).should == false
    -4.2.send(@method, 4.2).should == false
  end

  it "calls 'other == self' if coercion fails" do
    class CallsEqualEqualMock; def ==(other); 2.0 == other; end; end

    1.0.send(@method, CallsEqualEqualMock.new).should == false
    2.0.send(@method, CallsEqualEqualMock.new).should == true
  end
end
