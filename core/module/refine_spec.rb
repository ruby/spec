require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.2" do
  describe "Module#refine" do
    it "runs its block in an anonymous module" do
      inner_self = nil
      mod = Module.new do
        refine String do
          inner_self = self
        end
      end

      mod.should_not == inner_self
      inner_self.should be_kind_of(Module)
      inner_self.name.should == nil
    end

    it "uses the same anonymous module for future refines of the same class" do
      selves = []
      mod = Module.new do
        refine String do
          selves << self
        end
      end

      mod.module_eval do
        refine String do
          selves << self
        end
      end

      selves[0].should == selves[1]
    end

    it "adds methods defined in its block to the anonymous module's public instance methods" do
      inner_self = nil
      mod = Module.new do
        refine String do
          def blah
            "blah"
          end
          inner_self = self
        end
      end

      inner_self.public_instance_methods.should include(:blah)
    end

    it "returns created anonymous module" do
      inner_self = nil
      result = nil
      mod = Module.new do
        result = refine String do
          inner_self = self
        end
      end

      result.should == inner_self
    end

    it "raises ArgumentError if not passed an argument" do
      lambda do
        Module.new do
          refine {}
        end
      end.should raise_error(ArgumentError)
    end

    it "raises TypeError if not passed a class" do
      lambda do
        Module.new do
          refine("foo") {}
        end
      end.should raise_error(TypeError)
    end

    it "raises TypeError if passed a module" do
      lambda do
        Module.new do
          refine(Enumerable) {}
        end
      end.should raise_error(TypeError)
    end

    it "raises ArgumentError if not given a block" do
      lambda do
        Module.new do
          refine String
        end
      end.should raise_error(ArgumentError)
    end

    it "applies refinements to calls in the refine block" do
      result = nil
      Module.new do
        refine(String) do
          def foo; "foo"; end
          result = "hello".foo
        end
      end
      result.should == "foo"
    end

    it "doesn't apply refinements outside the refine block" do
      Module.new do
        refine(String) {def foo; "foo"; end}
        -> () {
          "hello".foo
        }.should raise_error(NoMethodError)
      end
    end

    it "does not apply refinements to external scopes not using the module" do
      Module.new do
        refine(String) {def foo; 'foo'; end}
      end

      lambda {"hello".foo}.should raise_error(NoMethodError)
    end
  end
end
