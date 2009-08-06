require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/method'

ruby_version_is "1.9" do
  describe "Kernel#public_method" do
    it_behaves_like(:kernel_method, :public_method)
  end
end
