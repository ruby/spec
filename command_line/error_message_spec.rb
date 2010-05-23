require File.expand_path('../../spec_helper', __FILE__)

describe "The error message caused by an exception" do

  before :all do
    @devnull = "/dev/null"
    platform_is :windows do
      @devnull = "NUL"
    end
  end

  it "is not printed to stdout" do
    out = ruby_exe("this_does_not_exist", :args => "2> #{@devnull}")
    out.chomp.empty?.should == true

    out = ruby_exe("end #syntax error", :args => "2> #{@devnull}")
    out.chomp.empty?.should == true
  end
end
