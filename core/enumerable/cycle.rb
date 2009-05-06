require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable#cycle" do
  ruby_version_is '1.8.7' do
    it "returns nil and does nothing for non positive n" do
      EnumerableSpecs::ThrowingEach.new.cycle(0){}.should be_nil
      EnumerableSpecs::NoEach.new.cycle(-22){}.should be_nil
    end    

    it "call each at most once" do
      enum = EnumerableSpecs::EachCounter.new(42, 1, 2)
      enum.cycle(3).to_a.should == [1,2,1,2,1,2]
      enum.times_called.should == 1
    end

    it "yield only when necessary" do
      enum = EnumerableSpecs::EachCounter.new(42, 10, 20, 30)
      enum.cycle(3){|x| break if x == 20}
      enum.times_yielded.should == 2
    end

    it "loop indefinitely if no n" do
      bomb = 10
      EnumerableSpecs::Numerous.new.cycle do
        bomb -= 1
        break 42 if bomb <= 0
      end.should == 42
      bomb.should == 0
    end
  end
end
