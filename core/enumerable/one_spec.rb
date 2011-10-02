require File.expand_path('../../../spec_helper', __FILE__)

describe "Enumerable#one?" do
  ruby_version_is '1.8.7' do
    describe "when block is given" do
      it "returns true if block returns true once" do
        ["ant", "bear", "cat"].one?{ |word| word.length == 4 }.should be_true
      end
      
      it "returns false if block evaluation are true more than once" do
        ["ant", "bear"].one? { |word| word.length > 4 }.should be_false
      end
    end
    
    describe "when block isn't given" do
      it "returns true if only one element is true" do
        [false, nil, true].one?.should be_true
      end
      
      it "returns false if two elements are true" do
        [false, true, nil, true].one?.should be_false
      end
      
      it "returns false if two elements aren't false or nil" do
        [false, true, nil, 99].one?.should be_false
      end
    end
  end
end
