require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/method'

describe "Kernel#method" do
  it_behaves_like(:kernel_method, :method)
end
