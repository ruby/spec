require_relative '../spec_helper'

describe "Magic comments" do
  ruby_version_is "3.0" do
    it 'makes constants shareable between ractors' do
      ->() { ruby_exe(fixture(__FILE__, 'shareable_constant_value_magic_comment.rb'), options: '-W0')}.should_not raise_error
    end
  end
end
