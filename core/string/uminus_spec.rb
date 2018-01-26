require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.3" do
  describe 'String#-@' do
    it 'returns self if the String is frozen' do
      input  = 'foo'.freeze
      output = -input

      output.equal?(input).should == true
      output.frozen?.should == true
    end

    it 'returns a frozen copy if the String is not frozen' do
      input  = 'foo'
      output = -input

      output.frozen?.should == true
      output.should == 'foo'
    end

    ruby_version_is "2.5" do
      it "returns the same object for equal unfrozen strings" do
        origin = -"this string is frozen"
        dynamic = -%w(this string is frozen).join(' ')

        origin.should equal dynamic
      end

      it "returns the same object when it's called on the same String literal" do
        (-"unfrozen string").should equal(-"unfrozen string")
      end
    end
  end
end
