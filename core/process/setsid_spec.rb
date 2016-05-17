require File.expand_path('../../../spec_helper', __FILE__)

describe "Process.setsid" do
  with_feature :fork do
    it "establishes this process as a new session and process group leader" do
      read, write = IO.pipe
      pid = Process.fork {
        begin
          read.close
          write << "\n"
          pgid = Process.setsid
          write << pgid
          write.close
        rescue Exception => e
          write << e << e.backtrace
        end
        Process.exit!
      }
      write.close
      read.gets
      pgid = Process.getsid(pid)
      pgid_child = read.gets
      read.close
      Process.wait pid

      pgid_child = Integer(pgid_child)
      pgid_child.should == pgid
      pgid_child.should_not == Process.getsid
    end
  end
end
