describe :io_binwrite, :shared => true do
  before :each do
    @filename = tmp("IO_write") + $$.to_s
  end
  
  after :each do
    rm_r @filename
  end
  
  it "writes the given string to the given filename" do
    IO.send(@method, @filename, 'hello').should == 5
    IO.binread(@filename).should == 'hello'
  end
  
  it "starts from the given offset, if provided" do
    IO.send(@method, @filename, 'hello', 4).should == 5
    IO.binread(@filename).should == "\000\000\000\000hello"
  end
end