require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

ruby_version_is "1.9" do
  describe "Kernel#public_send" do
    it "invokes the named public method" do
      class KernelSpecs::Foo
        def bar
          'done'
        end
      end
      KernelSpecs::Foo.new.public_send(:bar).should == 'done'
    end

    it "invokes the named alias of a public method" do
      class KernelSpecs::Foo
        alias :aka :bar
        def bar
          'done'
        end
      end
      KernelSpecs::Foo.new.public_send(:aka).should == 'done'
    end

    it "raises a NoMethodError if the method is protected" do
      class KernelSpecs::Foo
        protected
        def bar
          'done'
        end
      end
      lambda { KernelSpecs::Foo.new.public_send(:bar)}.should raise_error(NoMethodError)
    end

    it "raises a NoMethodError if the named method is private" do
      class KernelSpecs::Foo
        private
        def bar
          'done2'
        end
      end
      lambda { KernelSpecs::Foo.new.public_send(:bar) }.should 
        raise_error(NoMethodError)
    end

    it "raises a NoMethodError if the named method is an alias of a private method" do
      class KernelSpecs::Foo
        alias :aka :bar
        private
        def bar
          'done2'
        end
      end
      lambda { KernelSpecs::Foo.new.public_send(:aka) }.should 
        raise_error(NoMethodError)
    end

    it "raises a NoMethodError if the named method is an alias of a protected method" do
      class KernelSpecs::Foo
        alias :aka :bar
        protected
        def bar
          'done2'
        end
      end
      lambda { KernelSpecs::Foo.new.public_send(:aka) }.should 
        raise_error(NoMethodError)
    end

    it "invokes a class method if called on a class" do
      class KernelSpecs::Foo
        def self.bar
          'done'
        end
      end
      KernelSpecs::Foo.public_send(:bar).should == 'done'
    end

    it "raises a NameError if the corresponding method can't be found" do
      class KernelSpecs::Foo
        def bar
          'done'
        end
      end
      lambda { KernelSpecs::Foo.new.public_send(:baz) }.should raise_error(NameError)
    end

    it "raises a NameError if the corresponding singleton method can't be found" do
      class KernelSpecs::Foo
        def self.bar
          'done'
        end
      end
      lambda { KernelSpecs::Foo.public_send(:baz) }.should raise_error(NameError)
    end

    it "raises an ArgumentError if called with more arguments than available parameters" do
      class KernelSpecs::Foo
        def bar; end
      end

      lambda { KernelSpecs::Foo.new.public_send(:bar, :arg) }.should raise_error(ArgumentError)
    end

    it "raises an ArgumentError if called with fewer arguments than required parameters" do
      class KernelSpecs::Foo
        def foo(arg); end
      end

      lambda { KernelSpecs::Foo.new.public_send(:foo) }.should raise_error(ArgumentError)
    end

    it "succeeds if passed an arbitrary number of arguments as a splat parameter" do
      class KernelSpecs::Foo
        def baz(*args) args end
      end

      begin
        KernelSpecs::Foo.new.public_send(:baz).should == []
        KernelSpecs::Foo.new.public_send(:baz, :quux).should == [:quux]
        KernelSpecs::Foo.new.public_send(:baz, :quux, :foo).should == [:quux, :foo]
      rescue
        fail
      end
    end

    it "succeeds when passing 1 or more arguments as a required and a splat parameter" do
      class KernelSpecs::Foo
        def foo(first, *rest) [first, *rest] end
      end

      begin
        KernelSpecs::Foo.new.public_send(:baz, :quux).should == [:quux]
        KernelSpecs::Foo.new.public_send(:baz, :quux, :foo).should == [:quux, :foo]
      rescue
        fail
      end
    end

    it "succeeds when passing 0 arguments to a method with one parameter with a default" do
      class KernelSpecs::Foo
        def foo(first = true) first end
      end

      begin
        KernelSpecs::Foo.new.public_send(:foo).should == true
        KernelSpecs::Foo.new.public_send(:foo, :arg).should == :arg
      rescue
        fail
      end
    end
  end
end
