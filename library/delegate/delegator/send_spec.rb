require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "SimpleDelegator.new" do
  before :all do
    @simple = DelegateSpecs::Simple.new
    @delegate = SimpleDelegator.new(@simple)
  end

  it "forwards public method calls" do
    @delegate.pub.should == :foo
  end

  it "forwards protected method calls" do
    lambda{ @delegate.prot }.should raise_error( NoMethodError )
  end

  it "doesn't forward private method calls" do
    lambda{ @delegate.priv }.should raise_error( NoMethodError )
  end

  ruby_version_is "2.5" do
    it "forward private method calls if called in function form" do
      @delegate.instance_eval {priv(42)}.should == [:priv, 42]
    end
  end

  ruby_version_is ""..."2.5" do
    it "doesn't forward private method calls even via send or __send__" do
      lambda{ @delegate.send(:priv, 42)     }.should raise_error( NoMethodError )
      lambda{ @delegate.__send__(:priv, 42) }.should raise_error( NoMethodError )
    end
  end

  ruby_version_is "2.5" do
    it "forwards private method calls even via send or __send__" do
      @delegate.send(:priv, 42).should == [:priv, 42]
      @delegate.__send__(:priv, 42).should == [:priv, 42]
    end

    it "doesn't forward toplevel private method calls" do
      lambda{ @delegate.sprintf("") }.should raise_error( NoMethodError )
    end
  end
end
