require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../../../shared/hash/key_error', __FILE__)

ruby_version_is "2.3" do
  describe "Hash#fetch_values" do
    before :each do
      @hash = { a: 1, b: 2, c: 3 }
    end

    describe "with matched keys" do
      it "returns the values for keys" do
        @hash.fetch_values(:a).should == [1]
        @hash.fetch_values(:a, :c).should == [1, 3]
      end
    end

    describe "with unmatched keys" do
      it_behaves_like :key_error, ->(obj, key) { obj.fetch_values(key) }, Hash.new(a: 5)
    end

    describe "without keys" do
      it "returns an empty Array" do
        @hash.fetch_values.should == []
      end
    end
  end
end

ruby_version_is "2.5" do
  describe "Hash#fetch_values" do
    before :each do
      @hash = { a: 1, b: 2, c: 3 }
    end

    describe "with unmatched keys" do
      before :each do
      end
      it "sets the Hash as the receiver of KeyError" do
        -> {
          @hash.fetch_values :a, :z
        }.should raise_error(KeyError) { |err|
          err.receiver.should == @hash
        }
      end

      it "sets the unmatched key as the key of KeyError" do
        -> {
          @hash.fetch_values :a, :z
        }.should raise_error(KeyError) { |err|
          err.key.should == :z
        }
      end
    end
  end
end
