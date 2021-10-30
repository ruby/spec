require_relative '../spec_helper'

describe "Magic comments" do
  ruby_version_is "3.0" do
    it 'makes constants shareable between ractors' do
      -> { ruby_exe(fixture(__FILE__, 'shareable_constant_value_magic_comment.rb'), options: '-W0')}.should_not raise_error
    end

    it 'makes constants shareable between ractors' do
      a, b, c = Class.new.class_eval("#{<<~"begin;"}\n#{<<~'end;'}")
      begin;
        # shareable_constant_value: experimental_everything
        A = [[1]]
        # shareable_constant_value: none
        B = [[2]]
        # shareable_constant_value: literal
        C = [["shareable", "constant#{nil}"]]
        [A, B, C]
      end;
      Ractor.shareable?(a).should == true
      Ractor.shareable?(b).should == false
      Ractor.shareable?(c).should == true
    end

    it 'raises an error whenn shared constant is not a literal' do
      -> { Class.new.class_eval("#{<<~"begin;"}\n#{<<~'end;'}", /unshareable expression/) }.should raise_error
      begin;
        # shareable_constant_value: literal
        C = ["Not " + "shareable"]
      end;
    end
  end
end
