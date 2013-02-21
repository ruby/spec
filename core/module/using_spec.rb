require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0.0" do
  describe "Module#using" do
    before :each do
      @string_mod = Module.new do
        refine(String) {def foo; 'foo'; end}
      end
    end

    it "uses refinements from the given module for method calls in the target module" do
      string_mod = @string_mod

      mod = Module.new do
        using string_mod
        def self.go(str)
          str.foo
        end
      end

      mod.go('hello').should == 'foo'
    end

    it "uses refinements from the given module for method calls in subclasses" do
      string_mod = @string_mod

      cls = Class.new do
        using string_mod
      end
      cls2 = Class.new(cls) do
        def self.go(str)
          str.foo
        end
      end

      cls2.go('hello').should == 'foo'
    end

    it "does not affect methods defined before it is called" do
      cls = Class.new {def foo; 'foo'; end}
      mod = Module.new do
        refine(cls) do
          def foo; 'bar'; end
        end
      end
      mod2 = Module.new do
        def self.before_using(obj)
          obj.foo
        end
        using mod
        def self.after_using(obj)
          obj.foo
        end
      end

      mod2.before_using(cls.new).should == 'foo'
      mod2.after_using(cls.new).should == 'bar'
    end

    it "propagates refinements added to existing modules after it is called" do
      cls = Class.new {def foo; 'foo'; end}
      mod = Module.new do
        refine(cls) do
          def foo; 'quux'; end
        end
      end
      mod2 = Module.new do
        using mod
        def self.call_foo(obj)
          obj.foo
        end
        def self.call_bar(obj)
          obj.bar
        end
      end

      mod2.call_foo(cls.new).should == 'quux'

      mod.module_eval do
        refine(cls) do
          def bar; 'quux'; end
        end
      end

      mod2.call_bar(cls.new).should == 'quux'
    end

    it "does not propagate refinements of new modules added after it is called" do
      cls = Class.new {def foo; 'foo'; end}
      cls2 = Class.new {def bar; 'bar'; end}
      mod = Module.new do
        refine(cls) do
          def foo; 'quux'; end
        end
      end
      mod2 = Module.new do
        using mod
        def self.call_foo(obj)
          obj.foo
        end
        def self.call_bar(obj)
          obj.bar
        end
      end

      mod2.call_foo(cls.new).should == 'quux'

      mod.module_eval do
        refine(cls2) do
          def bar; 'quux'; end
        end
      end

      mod2.call_bar(cls2.new).should == 'bar'
    end
  end
end
