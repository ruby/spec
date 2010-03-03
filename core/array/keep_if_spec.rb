require File.expand_path('../shared/keep_if', __FILE__)

ruby_version_is "1.9" do
  describe "Array#keep_if" do
    it "returns the same array if no changes were made" do
      @array = [1, 2, 3]
      @array.keep_if { true }.object_id.should == @array.object_id
    end

    it_behaves_like :keep_if, :keep_if
  end
end
