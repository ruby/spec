require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../fixtures/env/classes'
require 'etc'

describe "Etc.getlogin" do
  it "returns the name of the user who runs this process" do
    Etc.getlogin.should == EnvSpecs.get_current_user
  end
end
