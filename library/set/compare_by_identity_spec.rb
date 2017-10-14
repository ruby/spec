require File.expand_path('../../../spec_helper', __FILE__)
require 'set'

ruby_version_is '2.4' do
  describe "Set#compare_by_identity" do
    it "compares its elements by identity" do
      a = "a"
      b1 = "b"
      b2 = "b"

      set = Set.new
      set.compare_by_identity
      set.merge([a, a, b1, b2])
      set.to_a.sort.should == [a, b1, b2].sort
    end

    it "returns self" do
      set = Set.new
      result = set.compare_by_identity
      result.should equal(set)
    end

    it "is idempotent and has no effect on an already compare_by_identity set" do
      set = Set.new.compare_by_identity
      set << :foo
      set.compare_by_identity.should equal(set)
      set.compare_by_identity?.should == true
      set.to_a.should == [:foo]
    end

    it "uses the semantics of BasicObject#equal? to determine key identity" do
      :a.equal?(:a).should == true
      Set.new.compare_by_identity.merge([:a, :a]).to_a.should == [:a]

      ary1 = [1]
      ary2 = [1]
      ary1.equal?(ary2).should == false
      Set.new.compare_by_identity.merge([ary1, ary2]).to_a.sort.should == [ary1, ary2].sort
    end

    it "uses #equal? semantics, but doesn't actually call #equal? to determine identity" do
      set = Set.new.compare_by_identity
      obj = mock("equal")
      obj.should_not_receive(:equal?)
      set << :foo
      set << obj
      set.to_a.should == [:foo, obj]
    end

    it "regards #dup'd objects as having different identities" do
      a1 = "a"
      a2 = a1.dup

      set = Set.new.compare_by_identity
      set.merge([a1, a2])
      set.to_a.sort.should == [a1, a2].sort
    end

    it "regards #clone'd objects as having different identities" do
      a1 = "a"
      a2 = a1.clone

      set = Set.new.compare_by_identity
      set.merge([a1, a2])
      set.to_a.sort.should == [a1, a2].sort
    end

    it "persists over #dups" do
      set = Set.new.compare_by_identity
      set << :a
      set_dup = set.dup
      set_dup.should == set
      set_dup << :a
      set_dup.to_a.should == [:a]
    end

    it "persists over #clones" do
      set = Set.new.compare_by_identity
      set << :a
      set_clone = set.clone
      set_clone.should == set
      set_clone << :a
      set_clone.to_a.should == [:a]
    end

    it "is not equal to set what does not compare by identity" do
      Set.new([1, 2]).should == Set.new([1, 2])
      Set.new([1, 2]).should_not == Set.new([1, 2]).compare_by_identity
    end
  end
end

ruby_version_is '2.4' do
  describe "Set#compare_by_identity?" do
    it "returns false by default" do
      Set.new.compare_by_identity?.should == false
    end

    it "returns true once #compare_by_identity has been invoked on self" do
      set = Set.new
      set.compare_by_identity
      set.compare_by_identity?.should == true
    end

    it "returns true when called multiple times on the same set" do
      set = Set.new
      set.compare_by_identity
      set.compare_by_identity?.should == true
      set.compare_by_identity?.should == true
      set.compare_by_identity?.should == true
    end
  end
end
