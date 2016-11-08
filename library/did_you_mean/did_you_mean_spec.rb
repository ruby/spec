ruby_version_is "2.3"..."2.4" do
  describe "with an incorrect spelling of" do
    describe "a constant" do
      it "suggests a correction to Ojbect" do
        lambda {Ojbect}.should raise_error{ |raised|
          raised.message.should == "uninitialized constant Ojbect\nDid you mean?  Object"
          raised.class.should == NameError
        }
      end

      it "suggests a correction to Klass" do
        lambda {Klass}.should raise_error{ |raised|
          raised.message.should == "uninitialized constant Klass\nDid you mean?  Class"
        }
      end
    end

    describe "an unmatched constant" do
      it "just highlights the error" do
        lambda {Math::Zap}.should raise_error{ |raised|
          raised.message.should == "uninitialized constant Math::Zap"
        }
      end
    end

    describe "a method" do
      it "suggests a correction to mehtods" do
        lambda {Class.mehtods}.should raise_error{ |raised|
          raised.class.should == NoMethodError
          raised.message.should == "undefined method `mehtods' for Class:Class
Did you mean?  methods" }
      end
    end

    describe "a method which has two possible matches" do
      it "suggests two possible corrections" do
        lambda {Object.includes?}.should raise_error{ |raised|
          raised.message.should == "undefined method `includes?' for Object:Class
Did you mean?  include?
               include"
        }
      end
    end

    describe "a method which has no close matches" do
      it "just highlights the error" do
        lambda {Object.*}.should raise_error{ |raised|
          raised.message.should == "undefined method `*' for Object:Class"
          raised.class.should == NoMethodError
        }
      end
    end

    describe "a class variable with a close match" do
      it "suggests a possible correction" do
        lambda {class X; @@buzz = 1; @@bizz end}.should raise_error{ |raised|
          raised.message.should == "uninitialized class variable @@bizz in X
Did you mean?  @@buzz"
          raised.class.should == NameError
        }
      end

      it "suggests a correction if @@ missing" do
        lambda {class X2; @@buzz = 1; buzz.inspect end}.should raise_error{ |raised|
          raised.message.should == "undefined local variable or method `buzz' for X2:Class
Did you mean?  @@buzz"
          raised.class.should == NameError
        }
      end

      it "suggests a possible correction even if match is a method" do
        lambda {class X; @@fud = 1; @@feee end}.should raise_error{ |raised|
          raised.message.should == "uninitialized class variable @@feee in X
Did you mean?  freeze"
          raised.class.should == NameError
        }
      end
    end

    describe "a class variable with two close matches" do
      it "suggests two possible corrections" do
        lambda {class Y; @@abc, @@abd = 2,3; @@abe.to_s end}.should raise_error{ |raised|
          raised.message.should == "uninitialized class variable @@abe in Y
Did you mean?  @@abc
               @@abd"
        }
      end
    end

    describe "a class variable with no close match" do
      it "just highlights the error" do
        lambda {Class.new{@@foo = nil; @@bar}}.should raise_error{ |raised|
          raised.message.should == "uninitialized class variable @@bar in Object"
        }
      end
    end

    describe "an instance variable with missing @" do
      it "suggests the correct instance variable" do
        lambda {
          class SomeClass
            @my_var = :some_var
            my_var.to:s
          end
        }.should raise_error{ |raised|
          raised.message.should == %q{undefined local variable or method `my_var' for SomeClass:Class
Did you mean?  @my_var}
        }
      end
    end
  end
end
