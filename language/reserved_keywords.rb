require_relative '../spec_helper'

describe "Ruby's reserved keywords" do
  # Copied from Prism::Translation::Ripper
  keywords = [
    "alias",
    "and",
    "begin",
    "BEGIN",
    "break",
    "case",
    "class",
    "def",
    "defined?",
    "do",
    "else",
    "elsif",
    "end",
    "END",
    "ensure",
    "false",
    "for",
    "if",
    "in",
    "module",
    "next",
    "nil",
    "not",
    "or",
    "redo",
    "rescue",
    "retry",
    "return",
    "self",
    "super",
    "then",
    "true",
    "undef",
    "unless",
    "until",
    "when",
    "while",
    "yield",
    "__ENCODING__",
    "__FILE__",
    "__LINE__"
  ]

  keywords.each do |kw|
    describe "keyword '#{kw}'" do
      it "can't be used as local variable name" do
        expect_syntax_error <<~RUBY
            #{kw} = "a local variable named '#{kw}'"
        RUBY
      end

      invalid_ivar_names = ["defined?"]

      if invalid_ivar_names.include?(kw)
        it "can't be used as an instance variable name" do
          expect_syntax_error <<~RUBY
            @#{kw} = "an instance variable named '#{kw}'"
          RUBY
        end
      else
        it "can be used as an instance variable name" do
          result = sandboxed_eval <<~RUBY
            @#{kw} = "an instance variable named '#{kw}'"
            @#{kw}
          RUBY

          result.should == "an instance variable named '#{kw}'"
        end
      end

      invalid_class_var_names = ["defined?"]

      if invalid_class_var_names.include?(kw)
        it "can't be used as a class variable name" do
          expect_syntax_error <<~RUBY
            @@#{kw} = "a class variable named '#{kw}'"
          RUBY
        end
      else
        it "can be used as a class variable name" do
          result = sandboxed_eval <<~RUBY
            @@#{kw} = "a class variable named '#{kw}'"
            @@#{kw}
          RUBY

          result.should == "a class variable named '#{kw}'"
        end
      end

      invalid_global_var_names = ["defined?"]

      if invalid_global_var_names.include?(kw)
        it "can't be used as a global variable name" do
          expect_syntax_error <<~RUBY
            $#{kw} = "a global variable named '#{kw}'"
          RUBY
        end
      else
        it "can be used as a global variable name" do
          result = sandboxed_eval <<~RUBY
            $#{kw} = "a global variable named '#{kw}'"
            $#{kw}
          RUBY

          result.should == "a global variable named '#{kw}'"
        end
      end

      it "can't be used as a positional parameter name" do
        expect_syntax_error <<~RUBY
          def x(#{kw}); end
        RUBY
      end

      invalid_kw_param_names = ["BEGIN","END","defined?"]

      if invalid_kw_param_names.include?(kw)
        it "can't be used a keyword parameter name" do
          expect_syntax_error <<~RUBY
            def m(#{kw}:); end
          RUBY
        end
      else
        it "can be used a keyword parameter name" do
          result = sandboxed_eval <<~RUBY
            def m(#{kw}:)
              binding.local_variable_get(:#{kw})
            end

            m(#{kw}: "an argument to '#{kw}'")
          RUBY

          result.should == "an argument to '#{kw}'"
        end
      end

      it "can be used as a method name" do
        result = sandboxed_eval <<~RUBY
          def #{kw}
            "a method named '#{kw}'"
          end

          send(:#{kw})
        RUBY

        result.should == "a method named '#{kw}'"
      end
    end
  end
end
