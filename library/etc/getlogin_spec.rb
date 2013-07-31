require File.expand_path('../../../spec_helper', __FILE__)
require 'etc'

describe "Etc.getlogin" do
  it "returns the name associated with the current login activity" do
    begin
      # make Etc.getlogin to return nil if getlogin(3) returns NULL
      envuser, ENV['USER'] = ENV['USER'], nil
      if Etc.getlogin
        # who -m is the user of tty attached to the stdout
        login = `who -m`[/\A\w+/]
        Etc.getlogin.should == login
      else
        # Etc.getlogin may return nil if the login name is not set
        # because of chroot or sudo or something.
        Etc.getlogin.should be_nil
      end
    ensure
      ENV['USER'] = envuser
    end

    if login.nil? && ENV['USER']
      Etc.getlogin.should == ENV['USER']
    end
  end
end
