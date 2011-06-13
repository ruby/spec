require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "Delegator#methods" do
  before :all do
    @simple = DelegateSpecs::Simple.new
    class << @simple
      def singleton_method
      end
    end
    
    @delegate = DelegateSpecs::Delegator.new(@simple)
    @methods = @delegate.methods
    @singleton_methods = @delegate.methods(false)
  end

  ruby_version_is ""..."1.9" do
    it "have one method in the singleton version return of methods" do
      @singleton_methods.length.should equal 1
      @singleton_methods.should include "singleton_method"
    end
    
    it "includes all public methods of the delegate object" do
      @methods.should include "pub"
    end

    it "includes all protected methods of the delegate object" do
      @methods.should include "prot"
    end

    it "includes instance methods of the Delegator class" do
      @methods.should include "extra"
      @methods.should include "extra_protected"
    end

    it "does not include private methods" do
      @methods.should_not include "priv"
      @methods.should_not include "extra_private"
    end
  end

  ruby_version_is "1.9" do
    it "includes all public methods of the delegate object" do
      @methods.should include :pub
    end

    it "includes all protected methods of the delegate object" do
      @methods.should include :prot
    end

    it "includes instance methods of the Delegator class" do
      @methods.should include :extra
      @methods.should include :extra_protected
    end

    it "does not include private methods" do
      @methods.should_not include :priv
      @methods.should_not include :extra_private
    end
  end
end
