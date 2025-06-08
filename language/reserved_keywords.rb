require_relative '../spec_helper'

describe "Ruby's reserved keywords" do
  # Copied from Prism::Translation::Ripper
  keywords = %w[
    alias
    and
    begin
    BEGIN
    break
    case
    class
    def
    defined?
    do
    else
    elsif
    end
    END
    ensure
    false
    for
    if
    in
    module
    next
    nil
    not
    or
    redo
    rescue
    retry
    return
    self
    super
    then
    true
    undef
    unless
    until
    when
    while
    yield
    __ENCODING__
    __FILE__
    __LINE__
  ]

  keywords.each do |kw|
    describe "keyword '#{kw}'" do
      it "can't be used as local variable name" do
        -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
            #{kw} = :local_variable
        RUBY
      end

      if kw == "defined?"
        it "can't be used as an instance variable name" do
          -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
            @#{kw} = :instance_variable
          RUBY
        end

        it "can't be used as a class variable name" do
          -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
            class C
              @@#{kw} = :class_variable
            end
          RUBY
        end

        it "can't be used as a global variable name" do
          -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
            $#{kw} = :global_variable
          RUBY
        end
      else
        it "can be used as an instance variable name" do
          result = eval <<~RUBY
            @#{kw} = :instance_variable
            @#{kw}
          RUBY

          result.should == :instance_variable
        end

        it "can be used as a class variable name" do
          result = eval <<~RUBY
            class C
              @@#{kw} = :class_variable
              @@#{kw}
            end
          RUBY

          result.should == :class_variable
        end

        it "can be used as a global variable name" do
          result = eval <<~RUBY
            $#{kw} = :global_variable
            $#{kw}
          RUBY

          result.should == :global_variable
        end
      end

      it "can't be used as a positional parameter name" do
        -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
          def x(#{kw}); end
        RUBY
      end

      invalid_kw_param_names = ["BEGIN","END","defined?"]

      if invalid_kw_param_names.include?(kw)
        it "can't be used a keyword parameter name" do
          -> { eval(<<~RUBY) }.should raise_error(SyntaxError)
            def m(#{kw}:); end
          RUBY
        end
      else
        it "can be used a keyword parameter name" do
          result = instance_eval <<~RUBY
            def m(#{kw}:)
              binding.local_variable_get(:#{kw})
            end

            m(#{kw}: :argument)
          RUBY

          result.should == :argument
        end
      end

      it "can be used as a method name" do
        result = instance_eval <<~RUBY
          def #{kw}
            :method_return_value
          end

          send(:#{kw})
        RUBY

        result.should == :method_return_value
      end
    end
  end
end
