require File.expand_path('../../../spec_helper', __FILE__)

describe "File.ctime" do
  before :each do
    @file = __FILE__
  end

  after :each do
    @file = nil
  end

  it "returns the change time for the named file (the time at which directory information about the file was changed, not the file itself)." do
    File.ctime(@file)
    File.ctime(@file).should be_kind_of(Time)
  end

  platform_is :linux do
    it "returns the change time for the named file (the time at which directory information about the file was changed, not the file itself) with microseconds." do
      file = tmp('ctime')
      3.times do
        touch file
        @ctime = File.ctime(file)
        break if @ctime.usec > 0
        rm_r file
        sleep 0.001
      end
      rm_r file
      @ctime.usec.should > 0
    end
  end

  it "accepts an object that has a #to_path method" do
    File.ctime(mock_to_path(@file))
  end

  it "raises an Errno::ENOENT exception if the file is not found" do
    lambda { File.ctime('bogus') }.should raise_error(Errno::ENOENT)
  end
end

describe "File#ctime" do
  before :each do
    @file = File.open(__FILE__)
  end

  after :each do
    @file.close
    @file = nil
  end

  it "returns the change time for the named file (the time at which directory information about the file was changed, not the file itself)." do
    @file.ctime
    @file.ctime.should be_kind_of(Time)
  end
end
