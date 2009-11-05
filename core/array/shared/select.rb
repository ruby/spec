describe :array_select, :shared => true do
  it "returns an instance of Enumerator if no block given" do
    [1, 2].send(@method).should be_kind_of(@object)
  end
end
