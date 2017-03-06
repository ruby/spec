require File.expand_path('../../../spec_helper', __FILE__)

describe "File.mtime" do
  before :each do
    @filename = tmp('i_exist')
    touch(@filename) { @mtime = Time.now }
  end

  after :each do
    rm_r @filename
  end

  it "returns the modification Time of the file" do
    File.mtime(@filename).should be_kind_of(Time)
    File.mtime(@filename).should be_close(@mtime, 2.0)
  end

  platform_is :linux do
    it "returns the modification Time of the file with microseconds" do
      3.times do
        touch(@filename)
        @mtime = File.mtime(@filename)
        break if @mtime.usec > 0
        sleep 0.001
      end
      @mtime.usec.should > 0
    end
  end

  it "raises an Errno::ENOENT exception if the file is not found" do
    lambda { File.mtime('bogus') }.should raise_error(Errno::ENOENT)
  end
end

describe "File#mtime" do
  before :each do
    @filename = tmp('i_exist')
    @f = File.open(@filename, 'w')
  end

  after :each do
    @f.close
    rm_r @filename
  end

  it "returns the modification Time of the file" do
    @f.mtime.should be_kind_of(Time)
  end

end
