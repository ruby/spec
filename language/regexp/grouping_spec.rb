require File.dirname(__FILE__) + '/../../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../fixtures/classes')

describe "Regexps with grouping" do
  it 'supports ()' do
    /(a)/.match("a").to_a.should == ["a", "a"]
  end

  it 'supports (?: ) (non-capturing group)' do
    /(?:foo)(bar)/.match("foobar").to_a.should == ["foobar", "bar"]
    # Parsing precedence
    /(?:xdigit:)/.match("xdigit:").to_a.should == ["xdigit:"]
  end
end
