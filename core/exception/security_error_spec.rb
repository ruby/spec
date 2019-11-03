require_relative '../../spec_helper'

describe "SecurityError" do
  # it "raises a SecurityError on a Regexp literal" do
  #   -> { //.send(:initialize, "") }.should raise_error(SecurityError)
  # end
  begin
    //.send(:initialize, "")
  rescue SecurityError => exception
    exception.message.should =~ /can't modify literal regexp/
  end
end
