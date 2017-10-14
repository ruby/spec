require File.expand_path('../../../spec_helper', __FILE__)
require 'set'
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.4" do
  describe "Set#compare_by_identity" do
    before :each do
      @set = Set.new
      @id_set = Set.new.compare_by_identity
    end

    it "causes future comparisons on the receiver to be made by identity" do
      elt = [1]
      @set << elt
      @set.member?(elt.dup).should be_true
      @set.compare_by_identity
      @set.member?(elt.dup).should be_false
    end

    it "rehashes internally so that old members can be looked up" do
      (1..10).each { |k| @set << k }
      o = Object.new
      def o.hash; 123; end
      @set << o
      @set.compare_by_identity
      @set.member?(o).should be_true
    end

    it "returns self" do
      @set << :bar
      @set.compare_by_identity.should equal @set
    end

    it "has no effect on an already compare_by_identity hash" do
      @id_set << :foo
      @id_set.compare_by_identity.should equal @id_set
      @id_set.compare_by_identity?.should be_true
      @id_set.member?(:foo).should be_true
    end

    it "uses the semantics of BasicObject#equal? to determine members identity" do
      [1].should_not equal([1])
      @id_set << [1]
      @id_set << [1]
      :bar.should equal(:bar)
      @id_set << :bar
      @id_set << :bar
      @id_set.to_a.should == [[1], [1], :bar]
    end

    it "uses #equal? semantics, but doesn't actually call #equal? to determine identity" do
      obj = mock('equal')
      obj.should_not_receive(:equal?)
      @id_set << :foo
      @id_set << obj
      @id_set.member?(obj).should be_true
    end

    it "does not call #hash on members" do
      elt = SetSpecs::ByIdentityKey.new
      @id_set << elt
      @id_set.member?(elt).should be_true
    end

    it "regards #dup'd objects as having different identities" do
      elt = ['foo']
      @id_set << elt.dup
      @id_set.member?(elt).should be_false
    end

    it "regards #clone'd objects as having different identities" do
      elt = ['foo']
      @id_set << elt.clone
      @id_set.member?(elt).should be_false
    end

    it "regards references to the same object as having the same identity" do
      o = Object.new
      @set << o
      @set << :a
      @set.member?(o).should be_true
    end

    it "raises a RuntimeError on frozen sets" do
      @set = @set.freeze
      lambda { @set.compare_by_identity }.should raise_error(RuntimeError)
    end

    # Behaviour confirmed in bug #1871
    it "persists over #dups" do
      @id_set << :bar
      @id_set << :glark
      @id_set.dup.should == @id_set
      @id_set.dup.size.should == @id_set.size
    end

    it "persists over #clones" do
      @id_set << :bar
      @id_set << :glark
      @id_set.clone.should == @id_set
      @id_set.clone.size.should == @id_set.size
    end

    it "does not copy string members" do
      foo = 'foo'
      @id_set << foo
      @id_set << foo
      @id_set.size.should == 1
      @id_set.first.object_id.should == foo.object_id
    end
  end

  describe "Set#compare_by_identity?" do
    it "returns false by default" do
      set = Set.new
      set.compare_by_identity?.should be_false
    end

    it "returns true once #compare_by_identity has been invoked on self" do
      set = Set.new
      set.compare_by_identity
      set.compare_by_identity?.should be_true
    end

    it "returns true when called multiple times on the same ident hash" do
      set = Set.new
      set.compare_by_identity
      set.compare_by_identity?.should be_true
      set.compare_by_identity?.should be_true
      set.compare_by_identity?.should be_true
    end
  end
end
