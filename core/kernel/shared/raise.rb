describe :kernel_raise, :shared => true do
  it "raises exception on current thread" do
    lambda { @object.raise("raises exception on current thread") }.should raise_error(RuntimeError, "raises exception on current thread")
  end
  
  it "raises RuntimeError if there is no active exception" do
    lambda { 1/0 }.should raise_error(ZeroDivisionError) # Throw some arbitrary exception to clear any "state"
    lambda { @object.raise }.should raise_error(RuntimeError, "")
  end
  
  it "re-raises active exception" do
    lambda {
      begin
        1/0
        flunk # ("should have thrown exception")
      rescue ZeroDivisionError
        @object.raise
      end
      flunk # ("did not re-raise exception")
    }.should raise_error(ZeroDivisionError)
  end
  
  it "allows Exception, message, and backtrace parameter" do
    lambda { @object.raise(ArgumentError, "message", caller) }.should raise_error(ArgumentError, "message")
  end
end
