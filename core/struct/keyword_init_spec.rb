require_relative '../../spec_helper'

describe "Struct#keyword_init?" do
  ruby_version_is '3.1' do # https://bugs.ruby-lang.org/issues/18008
    it "returns true if it's initialized with keyword_init: true option" do
      klass = Struct.new(:name, keyword_init: true)
      klass.keyword_init?.should == true
    end

    it "returns false if it's initialized with keyword_init: false option" do
      klass = Struct.new(:name, keyword_init: false)
      klass.keyword_init?.should == false
    end

    it "returns nil if it's initialized without keyword_init option" do
      klass = Struct.new(:name)
      klass.keyword_init?.should == nil
    end
  end
end
