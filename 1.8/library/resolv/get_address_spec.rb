require File.dirname(__FILE__) + '/../../spec_helper'

require 'resolv'

describe "Resolv#getaddress" do
	it 'resolves localhost' do
		lambda {
			address = Resolv.getaddress("localhost")
		}.should_not raise_error(Resolv::ResolvError)
		lambda {
			address = Resolv.getaddress("should.raise.error")
		}.should raise_error(Resolv::ResolvError)
	end

end
