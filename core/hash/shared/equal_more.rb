# All these tests are true for ==, and for eql? when Ruby >= 1.8.7
describe :hash_equal_more, :shared => true do
  it "compares values when keys match" do
    x = mock('x')
    y = mock('y')
    def x.==(o) false end
    def y.==(o) false end
    def x.eql?(o) false end
    def y.eql?(o) false end
    new_hash(1 => x).send(@method, new_hash(1 => y)).should == false

    x = mock('x')
    y = mock('y')
    def x.==(o) true end
    def y.==(o) true end
    def x.eql?(o) true end
    def y.eql?(o) true end
    new_hash(1 => x).send(@method, new_hash(1 => y)).should == true
  end
  
  it "compares keys with eql? semantics" do
    new_hash(1.0 => "x").send(@method, new_hash(1.0 => "x")).should == true
    new_hash(1.0 => "x").send(@method, new_hash(1.0 => "x")).should == true
    new_hash(1 => "x").send(@method, new_hash(1.0 => "x")).should == false
    new_hash(1.0 => "x").send(@method, new_hash(1 => "x")).should == false
  end
    
  it "returns true if other Hash has the same number of keys and each key-value pair matches" do
    new_hash(5).send(@method, new_hash(1)).should == true
    new_hash {|h, k| 1}.send(@method, new_hash {}).should == true
    new_hash {|h, k| 1}.send(@method, new_hash(2)).should == true

    a = new_hash(:a => 5)
    b = new_hash
    a.send(@method, b).should == false

    b[:a] = 5
    a.send(@method, b).should == true

    c = new_hash("a" => 5)
    a.send(@method, c).should == false

    d = new_hash {|h, k| 1}
    e = new_hash {}
    d[1] = 2
    e[1] = 2
    d.send(@method, e).should == true
  end
  
  it "does not call to_hash on hash subclasses" do
    new_hash(5 => 6).send(@method, ToHashHash[5 => 6]).should == true
  end

  it "ignores hash class differences" do
    h = new_hash(1 => 2, 3 => 4)
    MyHash[h].send(@method, h).should == true
    MyHash[h].send(@method, MyHash[h]).should == true
    h.send(@method, MyHash[h]).should == true
  end

  # Why isn't this true of eql? too ?
  it "compares keys with matching hash codes via eql?" do
    # Can't use should_receive because it uses hash and eql? internally
    a = Array.new(2) do
      obj = mock('0')

      def obj.hash()
        return 0
      end
      # It's undefined whether the impl does a[0].eql?(a[1]) or
      # a[1].eql?(a[0]) so we taint both.
      def obj.eql?(o)
        return true if self == o
        taint
        o.taint
        false
      end

      obj
    end

    new_hash(a[0] => 1).send(@method, new_hash(a[1] => 1)).should == false
    a[0].tainted?.should == true
    a[1].tainted?.should == true

    a = Array.new(2) do
      obj = mock('0')

      def obj.hash()
        # It's undefined whether the impl does a[0].send(@method, a[1]) or
        # a[1].send(@method, a[0]) so we taint both.
        def self.eql?(o) taint; o.taint; true; end
        return 0
      end

      obj
    end

    new_hash(a[0] => 1).send(@method, new_hash(a[1] => 1)).should == true
    a[0].tainted?.should == true
    a[1].tainted?.should == true
  end

  
end