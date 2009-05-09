require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'
require File.dirname(__FILE__) + '/shared/equal'
require File.dirname(__FILE__) + '/shared/equal_more'

# Do not use #should_receive(:eql?) mocks in these specs
# because MSpec uses Hash for mocks and Hash calls #eql?.

describe "Hash#eql?" do
  it_behaves_like :hash_equal, :eql?
  ruby_version_is '1.8.7' do
    it_behaves_like :hash_equal_more, :eql?
  end  
end
