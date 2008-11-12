require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#join" do
  it "returns an empty string if the Array is empty" do
    a = []
    a.join.should == ''
  end

  it "returns a string formed by concatenating each element.to_s separated by separator without trailing separator" do
    obj = mock('foo')
    def obj.to_s() 'foo' end
    [1, 2, 3, 4, obj].join(' | ').should == '1 | 2 | 3 | 4 | foo'

    obj = mock('o')
    class << obj; undef :to_s; end
    obj.should_receive(:method_missing).with(:to_s).and_return("o")
    [1, obj].join(":").should == "1:o"
  end

  it "raises a NoMethodError if an element does not respond to #to_s" do
    obj = mock('o')
    class << obj; undef :to_s; end
    lambda{ [1,obj].join }.should raise_error(NoMethodError, /to_s/)
  end
  
  it "uses the same separator with nested arrays" do
    [1, [2, [3, 4], 5], 6].join(":").should == "1:2:3:4:5:6"
    [1, [2, ArraySpecs::MyArray[3, 4], 5], 6].join(":").should == "1:2:3:4:5:6"
  end

  it "does not separates elements when the passed separator is nil" do
    [1, 2, 3].join(nil).should == '123'
  end

  it "uses $, as the default separator (which defaults to nil)" do
    [1, 2, 3].join.should == '123'
    begin
      old, $, = $,, '-'
      [1, 2, 3].join.should == '1-2-3'
    ensure
      $, = old
    end
  end
  
  it "tries to convert the passed seperator to a String using #to_str" do
    obj = mock('::')
    obj.should_receive(:to_str).and_return("::")
    [1, 2, 3, 4].join(obj).should == '1::2::3::4'
  end
  
  it "checks whether the passed seperator responds to #to_str" do
    obj = mock('.')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(true)
    obj.should_receive(:method_missing).with(:to_str).and_return(".")
    [1, 2].join(obj).should == "1.2"
  end

  it "raises a TypeError if the passed separator is not a string and does not respond to #to_str" do
    obj = mock('.')
    obj.should_receive(:respond_to?).with(:to_str).any_number_of_times.and_return(false)
    lambda { [1, 2].join(obj) }.should raise_error(TypeError)
  end

  it "does not process the separator if the array is empty" do
    a = []
    sep = Object.new
    a.join(sep).should == ""
  end

  # detail of joining recursive arrays is implementation depended. [ruby-dev:37021]
  it "handles recursive arrays" do
    x = []
    x << x
    x.join(':').should be_kind_of(String)

    x = ["one", "two"]
    x << x
    str = x.join('/')
    str.should include("one/two")

    x << "three"
    x << "four"
    str = x.join('/')
    str.should include("one/two")
    str.should include("three/four")

    # nested and recursive
    x = [["one", "two"], ["three", "four"]]
    x << x
    str = x.join('/')
    str.should include("one/two")
    str.should include("three/four")
    
    x = []
    y = []
    y << 9 << x << 8 << y << 7
    x << 1 << x << 2 << y << 3
    # representations when recursing from x
    # these are here to make it easier to understand what is happening
    str = x.join(':')
    str.should include('1')
    str.should include('2')
    str.should include('3')
  end

  it "does not consider taint of either the array or the separator when the array is empty" do
    [].join(":").tainted?.should == false
    [].taint.join(":").tainted?.should == false
    [].join(":".taint).tainted?.should == false
    [].taint.join(":".taint).tainted?.should == false
  end

  it "returns a string which would be infected with taint of the array, its elements or the separator when the array is not empty" do
    ["a", "b"].join(":").tainted?.should == false
    ["a", "b"].join(":".taint).tainted?.should == true
    ["a", "b"].taint.join(":").tainted?.should == true
    ["a", "b"].taint.join(":".taint).tainted?.should == true
    ["a", "b".taint].join(":").tainted?.should == true
    ["a", "b".taint].join(":".taint).tainted?.should == true
    ["a", "b".taint].taint.join(":").tainted?.should == true
    ["a", "b".taint].taint.join(":".taint).tainted?.should == true
    ["a".taint, "b"].join(":").tainted?.should == true
    ["a".taint, "b"].join(":".taint).tainted?.should == true
    ["a".taint, "b"].taint.join(":").tainted?.should == true
    ["a".taint, "b"].taint.join(":".taint).tainted?.should == true
    ["a".taint, "b".taint].join(":").tainted?.should == true
    ["a".taint, "b".taint].join(":".taint).tainted?.should == true
    ["a".taint, "b".taint].taint.join(":").tainted?.should == true
    ["a".taint, "b".taint].taint.join(":".taint).tainted?.should == true
  end

  ruby_version_is '1.9' do
    it "does not consider untrustworthiness of either the array or the separator when the array is empty" do 
      [].join(":").untrusted?.should == false
      [].untrust.join(":").untrusted?.should == false
      [].join(":".untrust).untrusted?.should == false
      [].untrust.join(":".untrust).untrusted?.should == false
    end

    it "returns a string which would be infected with untrustworthiness of the array, its elements or the separator when the array is not empty" do
      ["a", "b"].join(":").untrusted?.should == false
      ["a", "b"].join(":".untrust).untrusted?.should == true
      ["a", "b"].untrust.join(":").untrusted?.should == true
      ["a", "b"].untrust.join(":".untrust).untrusted?.should == true
      ["a", "b".untrust].join(":").untrusted?.should == true
      ["a", "b".untrust].join(":".untrust).untrusted?.should == true
      ["a", "b".untrust].untrust.join(":").untrusted?.should == true
      ["a", "b".untrust].untrust.join(":".untrust).untrusted?.should == true
      ["a".untrust, "b"].join(":").untrusted?.should == true
      ["a".untrust, "b"].join(":".untrust).untrusted?.should == true
      ["a".untrust, "b"].untrust.join(":").untrusted?.should == true
      ["a".untrust, "b"].untrust.join(":".untrust).untrusted?.should == true
      ["a".untrust, "b".untrust].join(":").untrusted?.should == true
      ["a".untrust, "b".untrust].join(":".untrust).untrusted?.should == true
      ["a".untrust, "b".untrust].untrust.join(":").untrusted?.should == true
      ["a".untrust, "b".untrust].untrust.join(":".untrust).untrusted?.should == true
    end
  end
end
