require File.expand_path('../spec_helper', __FILE__)

module FFISpecs
  describe "FFI.errno" do
    it "FFI.errno contains errno from last function" do
      LibTest.setLastError(0)
      LibTest.setLastError(0x12345678)
      FFI.errno.should == 0x12345678
    end
  end
end