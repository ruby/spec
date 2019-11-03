require_relative '../../spec_helper'

describe "SyntaxError" do
  it "gives a good message" do
    begin
      eval "i++"
    rescue SyntaxError => exception
      exception.message.should =~ /syntax error, unexpected end-of-input/
    end
  end
end
