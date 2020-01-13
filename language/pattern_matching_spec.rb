require_relative '../spec_helper'

ruby_version_is "2.7" do
  describe "Pattern matching" do
    before do
      ScratchPad.record []
    end

    it "can be standalone in operator that deconstructs value" do
      [0, 1] in [a, b]

      a.should == 0
      b.should == 1
    end

    it "extends case expression with case/in construction" do
      case [0, 1]
        in [0]
          :foo
        in [0, 1]
          :bar
      end.should == :bar
    end

    it "allows using then operator" do
      case [0, 1]
        in [0]    then :foo
        in [0, 1] then :bar
      end.should == :bar
    end

    it "warns about pattern matching is experimental feature" do
      -> {
        eval <<~CODE
          case 0
            in 0
          end
        CODE
      }.should complain(/warning: Pattern matching is experimental, and the behavior may change in future versions of Ruby!/)
    end

    it "binds variables" do
      case [0, 1]
        in [0, a]
          a
      end.should == 1
    end

    it "cannot mix in and when operators" do
      -> {
        eval <<~CODE
          case []
            when 1 == 1
            in []
          end
        CODE
      }.should raise_error(SyntaxError, /syntax error, unexpected `in'/)

      -> {
        eval <<~CODE
          case []
            in []
            when 1 == 1
          end
        CODE
      }.should raise_error(SyntaxError, /syntax error, unexpected `when'/)
    end

    it "checks patterns until the first matching" do
      case [0, 1]
        in [0]
          :foo
        in [0, 1]
          :bar
        in [0, 1]
          :baz
      end.should == :bar
    end

    it "executes else clause if no pattern matches" do
      case [0, 1]
        in [0]
          true
        else
          false
      end.should == false
    end

    it "raises NoMatchingPatternError if no pattern matches and no else clause" do
      -> {
        case [0, 1]
          in [0]
        end
      }.should raise_error(NoMatchingPatternError, /\[0, 1\]/)
    end

    describe "guards" do
      it "supports if guard" do
        case 0
          in 0 if false
            true
        else
          false
        end.should == false

        case 0
          in 0 if true
            true
        else
          false
        end.should == true
      end

      it "supports unless guard" do
        case 0
          in 0 unless true
            true
        else
          false
        end.should == false

        case 0
          in 0 unless false
            true
        else
          false
        end.should == true
      end

      it "makes bound variables visible in guard" do
        case [0, 1]
          in [a, 1] if a >= 0
            true
        end.should == true
      end

      it "does not evaluate guard if pattern does not match" do
        case 0
          in 1 if (ScratchPad << :foo) || true
        else
        end

        ScratchPad.recorded.should == []
      end

      it "takes guards into account when there are several matching patterns" do
        case 0
          in 0 if false
            :foo
          in 0 if true
            :bar
        end.should == :bar
      end

      it "executes else clause if no guarded pattern matches" do
        case 0
          in 0 if false
            true
        else
          false
        end.should == false
      end

      it "raises NoMatchingPatternError if no guarded pattern matches and no else clause" do
        -> {
          case [0, 1]
            in [0, 1] if false
          end
        }.should raise_error(NoMatchingPatternError, /\[0, 1\]/)
      end
    end

    describe "value pattern" do
      it "matches an object such that pattern === object" do
        case 0
          in 0
            true
        end.should == true

        case 0
          in (-1..1)
            true
        end.should == true

        case 0
          in Integer
            true
        end.should == true

        case "0"
          in /0/
            true
        end.should == true

        case "0"
          in ->(s) { s == "0" }
            true
        end.should == true
      end

      it "allows string literal with interpolation" do
        x = "x"

        case "x"
          in "#{x + ""}"
            true
        end.should == true
      end
    end

    describe "variable pattern" do
      it "matches a value and binds variable name to this value" do
        case 0
          in a
            a
        end.should == 0
      end

      it "makes bounded variable visible outside a case statement scope" do
        case 0
          in a
        end

        a.should == 0
      end

      it "allow using _ name to drop values" do
        case [0, 1]
          in [a, _]
            a
        end.should == 0
      end

      it "supports using _ in a pattern several times" do
        case [0, 1, 2]
          in [0, _, _]
            _
        end.should == 2
      end

      it "supports using any name with _ at the beginning in a pattern several times" do
        case [0, 1, 2]
          in [0, _x, _x]
            _x
        end.should == 2

        case {a: 0, b: 1, c: 2}
          in {a: 0, b: _x, c: _x}
            _x
        end.should == 2
      end

      it "does not support using variable name (except _) several times" do
        -> {
          eval <<~CODE
            case [0]
              in [a, a]
            end
          CODE
        }.should raise_error(SyntaxError, /duplicated variable name/)
      end

      it "supports existing variables in a pattern specified with ^ operator" do
        a = 0

        case 0
          in ^a
            true
        end.should == true
      end

      it "allows applying ^ operator to bound variables" do
        case [1, 1]
          in [n, ^n]
            n
        end.should == 1

        case [1, 2]
          in [n, ^n]
            true
        else
          false
        end.should == false
      end
    end

    describe "alternative pattern" do
      it "matches if any of patterns matches" do
        case 0
          in 0 | 1 | 2
            true
        end.should == true
      end

      it "does not support variable binding" do
        -> {
          eval <<~CODE
            case [0, 1]
              in [0, 0] | [0, a]
            end
          CODE
        }.should raise_error(SyntaxError, /illegal variable in alternative pattern/)
      end
    end

    describe "AS pattern" do
      it "binds a variable to a value if pattern matches" do
        case 0
          in Integer => n
            n
        end.should == 0
      end

      it "can be used as a nested pattern" do
        case [1, [2, 3]]
          in [1, Array => ary]
            ary
        end.should == [2, 3]
      end
    end

    describe "Array pattern" do
      it "supports form Constant(pat, pat, ...)" do
        case [0, 1, 2]
          in Array(0, 1, 2)
            true
        end.should == true
      end

      it "supports form Constant[pat, pat, ...]" do
        case [0, 1, 2]
          in Array[0, 1, 2]
            true
        end.should == true
      end

      it "supports form [pat, pat, ...]" do
        case [0, 1, 2]
          in [0, 1, 2]
            true
        end.should == true
      end

      it "supports form pat, pat, ..." do
        case [0, 1, 2]
          in 0, 1, 2 then
            true
        end.should == true

        case [0, 1, 2]
          in 0, a, 2
            a
        end.should == 1

        case [0, 1, 2]
          in 0, *rest
            rest
        end.should == [1, 2]
      end

      it "matches an object with #deconstruct method which returns an array and each element in array matches element in pattern" do
        obj = Object.new
        def obj.deconstruct; [0, 1] end

        case obj
          in [Integer, Integer]
            true
        end.should == true
      end

      it "does not match object if Constant === object returns false" do
        case [0, 1, 2]
          in String[0, 1, 2]
            true
        else
          false
        end.should == false
      end

      it "does not match object without #deconstruct method" do
        obj = Object.new

        case obj
          in Object[]
            true
        else
          false
        end.should == false
      end

      it "raises TypeError if #deconstruct method does not return array" do
        obj = Object.new
        def obj.deconstruct; "" end

        -> {
          case obj
            in Object[]
          else
          end
        }.should raise_error(TypeError, /deconstruct must return Array/)
      end

      it "does not match object if elements of array returned by #deconstruct method does not match elements in pattern" do
        obj = Object.new
        def obj.deconstruct; [1] end

        case obj
          in Object[0]
            true
        else
          false
        end.should == false
      end

      it "binds variables" do
        case [0, 1, 2]
          in [a, b, c]
            [a, b, c]
        end.should == [0, 1, 2]
      end

      it "binds variable even if patter matches only partially" do
        a = nil

        case [0, 1, 2]
          in [a, 1, 3]
        else
        end

        a.should == 0
      end

      it "supports splat operator *rest" do
        case [0, 1, 2]
          in [0, *rest]
            rest
        end.should == [1, 2]
      end

      it "does not match partially by default" do
        case [0, 1, 2, 3]
          in [1, 2]
            true
        else
          false
        end.should == false
      end

      it "does match partially from the array beginning if list + , syntax used" do
        case [0, 1, 2, 3]
          in [0, 1,]
            true
        end.should == true

        case [0, 1, 2, 3]
          in 0, 1,;
            true
        end.should == true
      end

      it "matches [] with []" do
        case []
          in []
            true
        end.should == true
      end
    end

    describe "Hash pattern" do
      it "supports form Constant(id: pat, id: pat, ...)" do
        case {a: 0, b: 1}
          in Hash(a: 0, b: 1)
            true
        end.should == true
      end

      it "supports form Constant[id: pat, id: pat, ...]" do
        case {a: 0, b: 1}
          in Hash[a: 0, b: 1]
            true
        end.should == true
      end

      it "supports form {id: pat, id: pat, ...}" do
        case {a: 0, b: 1}
          in {a: 0, b: 1}
            true
        end.should == true
      end

      it "supports form id: pat, id: pat, ..." do
        case {a: 0, b: 1}
          in a: 0, b: 1
            true
        end.should == true

        case {a: 0, b: 1}
          in a: a, b: b
            [a, b]
        end.should == [0, 1]

        case {a: 0, b: 1, c: 2}
          in a: 0, **rest
            rest
        end.should == { b: 1, c: 2 }
      end

      it "supports a: which means a: a" do
        case {a: 0, b: 1}
          in Hash(a:, b:)
            [a, b]
        end.should == [0, 1]

        a = b = nil
        case {a: 0, b: 1}
          in Hash[a:, b:]
            [a, b]
        end.should == [0, 1]

        a = b = nil
        case {a: 0, b: 1}
          in {a:, b:}
            [a, b]
        end.should == [0, 1]

        a = nil
        case {a: 0, b: 1, c: 2}
          in {a:, **rest}
            [a, rest]
        end.should == [0, {b: 1, c: 2}]

        a = b = nil
        case {a: 0, b: 1}
          in a:, b:
            [a, b]
        end.should == [0, 1]
      end

      it 'supports "str": key literal' do
        case {a: 0}
          in {"a": 0}
            true
        end.should == true
      end

      it "does not support non-symbol keys" do
        -> {
          eval <<~CODE
            case {a: 1}
              in {"a" => 1}
            end
          CODE
        }.should raise_error(SyntaxError, /unexpected/)
      end

      it "does not support string interpolation in keys" do
        x = "a"

        -> {
          eval <<~'CODE'
            case {a: 1}
              in {"#{x}": 1}
            end
          CODE
        }.should raise_error(SyntaxError, /symbol literal with interpolation is not allowed/)
      end

      it "raise SyntaxError when keys duplicate in pattern" do
        -> {
          eval <<~CODE
            case {a: 1}
              in {a: 1, b: 2, a: 3}
            end
          CODE
        }.should raise_error(SyntaxError, /duplicated key name/)
      end

      it "matches an object with #deconstruct_keys method which returns a Hash with equal keys and each value in Hash matches value in pattern" do
        obj = Object.new
        def obj.deconstruct_keys(*); {a: 1} end

        case obj
          in {a: 1}
            true
        end.should == true
      end

      it "does not match object if Constant === object returns false" do
        case {a: 1}
          in String[a: 1]
            true
        else
          false
        end.should == false
      end

      it "does not match object without #deconstruct_keys method" do
        obj = Object.new

        case obj
          in Object[a: 1]
            true
        else
          false
        end.should == false
      end

      it "does not match object if #deconstruct_keys method does not return Hash" do
        obj = Object.new
        def obj.deconstruct_keys(*); "" end

        -> {
          case obj
            in Object[a: 1]
          end
        }.should raise_error(TypeError, /deconstruct_keys must return Hash/)
      end

      it "does not match object if #deconstruct_keys method returns Hash with non-symbol keys" do
        obj = Object.new
        def obj.deconstruct_keys(*); {"a" => 1} end

        case obj
          in Object[a: 1]
            true
        else
          false
        end.should == false
      end

      it "does not match object if elements of Hash returned by #deconstruct_keys method does not match values in pattern" do
        obj = Object.new
        def obj.deconstruct_keys(*); {a: 1} end

        case obj
          in Object[a: 2]
            true
        else
          false
        end.should == false
      end

      it "passes keys specified in pattern as arguments to #deconstruct_keys method" do
        obj = Object.new

        def obj.deconstruct_keys(*args)
          ScratchPad << args
          {a: 1, b: 2, c: 3}
        end

        case obj
          in Object[a: 1, b: 2, c: 3]
        end

        ScratchPad.recorded.should == [[[:a, :b, :c]]]
      end

      it "passes keys specified in pattern to #deconstruct_keys method if pattern contains double splat operator **" do
        obj = Object.new

        def obj.deconstruct_keys(*args)
          ScratchPad << args
          {a: 1, b: 2, c: 3}
        end

        case obj
          in Object[a: 1, b: 2, **]
        end

        ScratchPad.recorded.should == [[[:a, :b]]]
      end

      it "passes nil to #deconstruct_keys method if pattern contains double splat operator **rest" do
        obj = Object.new

        def obj.deconstruct_keys(*args)
          ScratchPad << args
          {a: 1, b: 2}
        end

        case obj
          in Object[a: 1, **rest]
        end

        ScratchPad.recorded.should == [[nil]]
      end

      it "binds variables" do
        case {a: 0, b: 1, c: 2}
          in {a: x, b: y, c: z}
            [x, y, z]
        end.should == [0, 1, 2]
      end

      it "binds variable even if patter matches only partially" do
        x = nil

        case {a: 0, b: 1}
          in {a: x, b: 2}
        else
        end

        x.should == 0
      end

      it "supports double splat operator **rest" do
        case {a: 0, b: 1, c: 2}
          in {a: 0, **rest}
            rest
        end.should == {b: 1, c: 2}
      end

      it "treats **nil like there should not be any other keys in a matched Hash" do
        case {a: 1, b: 2}
          in {a: 1, b: 2, **nil}
            true
        end.should == true

        case {a: 1, b: 2}
          in {a: 1, **nil}
            true
        else
          false
        end.should == false
      end

      it "can match partially" do
        case {a: 1, b: 2}
          in {a: 1}
            true
        end.should == true
      end

      it "matches {} with {}" do
        case {}
          in {}
            true
        end.should == true
      end
    end
  end
end
