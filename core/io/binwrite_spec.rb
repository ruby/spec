require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/write', __FILE__)

ruby_version_is "1.9" do
  describe "IO.binwrite" do
    it_behaves_like :io_write_sing, :binwrite
  end
end
