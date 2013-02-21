require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0.0" do
  require File.expand_path('../fixtures/string_refinement', __FILE__)

  describe "Kernel#using" do
    it "requires one or more Module arguments" do
      lambda do
        Module.new do
          using
        end
      end.should raise_error(ArgumentError)

      lambda do
        Module.new do
          using 'foo'
        end
      end.should raise_error(TypeError)
    end

    it "uses refinements from the given module for method calls in the target module" do
      mod = Module.new do
        using StringRefinement
        def self.go(str)
          str.foo
        end
      end

      mod.go('hello').should == 'foo'
    end

    it "uses refinements from the given module for method calls in subclasses" do
      cls = Class.new do
        using StringRefinement
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

    it "applies used refinements to module/class_eval blocks" do
      mod = Module.new do
        using StringRefinement
      end

      mod.module_eval {'hello'.foo}.should == 'foo'
      mod.class_eval {'hello'.foo}.should == 'foo'
    end

    it "applies used refinements to lambda blocks" do
      lambda do
        using StringRefinement
        'hello'.foo
      end.call.should == 'foo'
    end

    ruby_bug "in a_matsuda's slides but does not appear to work", "2.0.1" do
      it "applies used refinements to nested closures inside module/class_eval" do
	mod = Module.new do
	  using StringRefinement
	end

	mod.module_eval { lambda { 'hello'.say } }.call.should == 'foo'
	mod.class_eval { lambda { 'hello'.say } }.call.should == 'foo'
      end
    end
  end
end
