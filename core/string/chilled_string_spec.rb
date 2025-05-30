require_relative '../../spec_helper'

describe "chilled String" do
  guard -> { ruby_version_is "3.4" and !"test".equal?("test") } do
    describe "chilled string literals" do

      describe "#frozen?" do
        it "returns false" do
          "chilled".frozen?.should == false
        end
      end

      describe "#-@" do
        it "returns a different instance" do
          input = "chilled"
          interned = (-input)
          interned.frozen?.should == true
          interned.object_id.should_not == input.object_id
        end
      end

      describe "#+@" do
        it "returns a different instance" do
          input = "chilled"
          duped = (+input)
          duped.frozen?.should == false
          duped.object_id.should_not == input.object_id
        end
      end

      describe "#clone" do
        it "preserves chilled status" do
          input = "chilled".clone
          -> {
            input << "-mutated"
          }.should complain(/literal string will be frozen in the future/)
          input.should == "chilled-mutated"
        end
      end

      describe "mutation" do
        it "emits a warning" do
          input = "chilled"
          -> {
            input << "-mutated"
          }.should complain(/literal string will be frozen in the future/)
          input.should == "chilled-mutated"
        end

        it "emits a warning on singleton_class creation" do
          -> {
            "chilled".singleton_class
          }.should complain(/literal string will be frozen in the future/)
        end

        it "emits a warning on instance variable assignment" do
          -> {
            "chilled".instance_variable_set(:@ivar, 42)
          }.should complain(/literal string will be frozen in the future/)
        end

        it "raises FrozenError after the string was explicitly frozen" do
          input = "chilled"
          input.freeze
          -> {
            -> {
              input << "mutated"
            }.should raise_error(FrozenError)
          }.should_not complain(/literal string will be frozen in the future/)
        end
      end
    end

    describe "chilled strings returned by Symbol#to_s" do

      describe "#frozen?" do
        it "returns false" do
          :chilled.to_s.frozen?.should == false
        end
      end

      describe "#-@" do
        it "returns a different instance" do
          input = :chilled.to_s
          interned = (-input)
          interned.frozen?.should == true
          interned.object_id.should_not == input.object_id
        end
      end

      describe "#+@" do
        it "returns a different instance" do
          input = :chilled.to_s
          duped = (+input)
          duped.frozen?.should == false
          duped.object_id.should_not == input.object_id
        end
      end

      describe "#clone" do
        it "preserves chilled status" do
          input = :chilled.to_s.clone
          -> {
            input << "-mutated"
          }.should complain(/string returned by :chilled\.to_s will be frozen in the future/)
          input.should == "chilled-mutated"
        end
      end

      describe "mutation" do
        it "emits a warning" do
          input = :chilled.to_s
          -> {
            input << "-mutated"
          }.should complain(/string returned by :chilled\.to_s will be frozen in the future/)
          input.should == "chilled-mutated"
        end

        it "emits a warning on singleton_class creation" do
          -> {
            :chilled.to_s.singleton_class
          }.should complain(/string returned by :chilled\.to_s will be frozen in the future/)
        end

        it "emits a warning on instance variable assignment" do
          -> {
            :chilled.to_s.instance_variable_set(:@ivar, 42)
          }.should complain(/string returned by :chilled\.to_s will be frozen in the future/)
        end

        it "raises FrozenError after the string was explicitly frozen" do
          input = :chilled.to_s
          input.freeze
          -> {
            -> {
              input << "mutated"
            }.should raise_error(FrozenError)
          }.should_not complain(/string returned by :chilled\.to_s will be frozen in the future/)
        end
      end
    end
  end
end
