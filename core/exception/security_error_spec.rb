require_relative '../../spec_helper'

describe "SecurityError" do
  it "gives a good message" do
    @saved_safe = $SAFE
    begin
      $SAFE = 1
      proc = Proc.new do
        require 'rake'
      end
      proc.call
    rescue SecurityError => exception
      exception.message.should =~ /Insecure operation - gem_original_require/
    ensure
      $SAFE = @saved_safe
    end
  end
end
