require File.expand_path('../../../spec_helper', __FILE__)
require 'etc'

describe "Etc.getlogin" do
  it "returns the name associated with the current login activity or nil" do
    nil_p = false
    begin
      # make Etc.getlogin to return nil if getlogin(3) returns NULL
      envuser, ENV['USER'] = ENV['USER'], nil
      if Etc.getlogin
        Etc.getlogin.should == `logname`.chomp
      else
        # Etc.getlogin may return nil if the login name is not set
        # because of chroot or sudo or something.
        Etc.getlogin.should be_nil
        nil_p = true
      end
    ensure
      ENV['USER'] = envuser
    end

    if nil_p
      Etc.getlogin.should == ENV['USER']
    end
  end
end
