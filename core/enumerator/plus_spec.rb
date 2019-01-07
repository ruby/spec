require_relative '../../spec_helper'

ruby_version_is "2.6" do
  describe "Enumerator#+" do
    before :each do
      ScratchPad.record []
    end

    it "returns a chain of self and provided enumerators" do
      one   = Enumerator.new { |y| y << 1 }
      two   = Enumerator.new { |y| y << 2 }
      three = Enumerator.new { |y| y << 3 }

      chain = one + two + three

      chain.should be_an_instance_of(Enumerator::Chain)
      chain.each { |item| ScratchPad << item }
      ScratchPad.recorded.should == [1, 2, 3]
    end
  end
end
