require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Enumerable.map with implicit to_proc [each(&obj) form]" do    
  
  it "calls obj.to_proc" do 
    EnumerableSpecs::Numerous.new.map(&:succ).should == [3, 6, 4, 7, 2, 5]
  end 

  it "does not call obj.to_proc if obj.is_a? Proc" do

    f = lambda{ |x| x + 1 }
    class << f
      def to_proc
	lambda{ |x| 42 }
      end
    end
    EnumerableSpecs::Numerous.new.map(&f).should == [3, 6, 4, 7, 2, 5]

    myproc = Class::new Proc do
      def to_proc
	lambda{ |x| 42 }
      end
    end
    inc = myproc::new{ |x| x + 1 }
    EnumerableSpecs::Numerous.new.map(&inc).should == [4, 6, 4, 7, 2, 5]
    
  end
end
