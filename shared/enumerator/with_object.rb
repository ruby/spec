require File.expand_path('../../../spec_helper', __FILE__)

describe :enum_with_object, :shared => true do
  it "returns an enumerator when not given a block" do
    [].to_enum.send(@method, '').should be_an_instance_of(enumerator_class)
  end

  it "returns the given object when given a block" do
    object = ''
    ret = [].to_enum.send(@method, object) do |elm, obj|
      # nothing
    end
    ret.should equal(object)
  end

  it "iterates over the array adding the given object" do
    expected = ''
    %w|wadus wadus|.to_enum.send(@method, ' ') {|e, o| expected += e + o}

    expected.should == 'wadus wadus '
  end
end
