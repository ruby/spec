describe :keep_if, :shared => true do
  it "deletes elements for which the block returns a false value" do
    @array = [1, 2, 3, 4, 5]
    @array.send(@method) {|item| item > 3 }.should == @array
    @array.should == [4, 5]
  end

  it "returns an enumerator if no block is given" do
    [1, 2, 3].send(@method).should be_kind_of(Enumerator)
  end
end
