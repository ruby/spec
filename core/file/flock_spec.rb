require File.expand_path('../../../spec_helper', __FILE__)

describe "File#flock" do
  before :each do
    ScratchPad.record []

    @name = tmp("flock_test")
    touch(@name)

    @file = File.open @name, "w+"
  end

  after :each do
    @file.flock File::LOCK_UN
    @file.close

    rm_r @name
  end

  it "exclusively locks a file" do
    @file.flock(File::LOCK_EX).should == 0
    @file.flock(File::LOCK_UN).should == 0
  end

  it "non-exclusively locks a file" do
    @file.flock(File::LOCK_SH).should == 0
    @file.flock(File::LOCK_UN).should == 0
  end

  it "returns false if trying to lock an exclusively locked file" do
    @file.flock File::LOCK_EX

    ruby_exe(<<-END_OF_CODE, escape: true).should == "false"
      File.open('#{@name}', "w") do |f2|
        print f2.flock(File::LOCK_EX | File::LOCK_NB).to_s
      end
    END_OF_CODE
  end

  it "blocks if trying to lock an exclusively locked file" do
    @file.flock File::LOCK_EX

    t = Thread.new do
      ruby_exe(<<-END_OF_CODE, escape: true)
        File.open('#{@name}', "w") do |f2|
          begin
            f2.puts Process.pid
            f2.puts "before"
            f2.flush
            f2.flock(File::LOCK_EX)
            f2.puts "after"
          rescue Interrupt
            f2.puts "interrupt"
          end
        end
      END_OF_CODE
    end

    begin
      @file.seek(0, IO::SEEK_SET)
      begin
        s = @file.read_nonblock(127)
      rescue EOFError, Errno::EAGAIN, Errno::EWOULDBLOCK
      end
    end until /before/ =~ s.to_s

    sleep 0.5
    Process.kill("INT", s.to_i)
    t.join

    @file.seek(0, IO::SEEK_SET)
    a = @file.read.to_s.strip.split(/\s+/)
    a.shift
    a.should == [ 'before', 'interrupt' ]
  end

  it "returns 0 if trying to lock a non-exclusively locked file" do
    @file.flock File::LOCK_SH

    File.open(@name, "r") do |f2|
      f2.flock(File::LOCK_SH | File::LOCK_NB).should == 0
      f2.flock(File::LOCK_UN).should == 0
    end
  end

  platform_is :solaris, :java do
    before :each do
      @read_file = File.open @name, "r"
      @write_file = File.open @name, "w"
    end

    after :each do
      @read_file.flock File::LOCK_UN
      @read_file.close
      @write_file.flock File::LOCK_UN
      @write_file.close
    end

    it "fails with EBADF acquiring exclusive lock on read-only File" do
      lambda do
        @read_file.flock File::LOCK_EX
      end.should raise_error(Errno::EBADF)
    end

    it "fails with EBADF acquiring shared lock on read-only File" do
      lambda do
        @write_file.flock File::LOCK_SH
      end.should raise_error(Errno::EBADF)
    end
  end
end
