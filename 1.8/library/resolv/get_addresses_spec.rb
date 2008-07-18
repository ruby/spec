require File.dirname(__FILE__) + '/../../spec_helper'

require 'resolv'

describe "Resolv#getaddresses" do
	it 'resolves localhost' do
		addresses = nil
		lambda {
			addresses = Resolv.getaddresses("localhost")
		}.should_not raise_error(Resolv::ResolvError)
		addresses.should_not == nil
		addresses.size.should > 0
	end

end
