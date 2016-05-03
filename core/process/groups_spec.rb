require File.expand_path('../../../spec_helper', __FILE__)

describe "Process.groups" do
  platform_is_not :windows do
    it "gets an Array of the gids of groups in the supplemental group access list" do
      groups = `id -G`.scan(/\d+/).map {|i| i.to_i}

      Process.groups.each do |g|
        groups.should include(g)
      end
    end

    # NOTE: This is kind of sketchy.
    it "sets the list of gids of groups in the supplemental group access list" do
      groups = Process.groups
      if Process.uid == 0
        Process.groups = []
        Process.groups.should == []
        Process.groups = groups
        Process.groups.sort.should == groups.sort
      else
        platform_is :aix do
          # setgroups() is not part of the POSIX standard,
          # so its behavior varis from OS to OS.  AIX allows a non-root
          # process to set the supplementary group IDs, as long as
          # they are presently in its supplementary group IDs.
          # The order of the following three tests matter.
          # After this process executes "Process.groups = []"
          # it should no longer be able to set any supplementary
          # group IDs, even if it originally belonged to them.
          Process.groups = groups
          Process.groups.sort.should == groups.sort
          Process.groups = []
          Process.groups.should == []
          lambda { Process.groups = groups }.should raise_error(Errno::EPERM)
        end
        platform_is_not :aix do
          lambda { Process.groups = [] }.should raise_error(Errno::EPERM)
        end
      end
    end
  end
end

describe "Process.groups=" do
  it "needs to be reviewed for spec completeness"
end
