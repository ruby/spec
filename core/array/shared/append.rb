describe :array_append, shared: true do
  it "appends the arguments to the array" do
    a = [ "a", "b", "c" ]
    a.__send__(@method, "d", "e", "f").should equal(a)
    a.__send__(@method).should == ["a", "b", "c", "d", "e", "f"]
    a.__send__(@method, 5)
    a.should == ["a", "b", "c", "d", "e", "f", 5]

    a = [0, 1]
    a.__send__(@method, 2)
    a.should == [0, 1, 2]
  end

  it "isn't confused by previous shift" do
    a = [ "a", "b", "c" ]
    a.shift
    a.__send__(@method, "foo")
    a.should == ["b", "c", "foo"]
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.__send__(@method, :last).should == [empty, :last]

    array = ArraySpecs.recursive_array
    array.__send__(@method, :last).should == [1, 'two', 3.0, array, array, array, array, array, :last]
  end

  it "raises a RuntimeError on a frozen array" do
    lambda { ArraySpecs.frozen_array.__send__(@method, 1) }.should raise_error(RuntimeError)
    lambda { ArraySpecs.frozen_array.__send__(@method) }.should raise_error(RuntimeError)
  end
end
