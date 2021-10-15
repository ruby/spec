require_relative '../spec_helper'

ruby_version_is "3.0" do
  describe "The --backtrace-limit command line option" do
    it "limits top-level backtraces to a given number of entries" do
      file = fixture(__FILE__ , "backtrace.rb")
      out = ruby_exe(file, options: "--backtrace-limit=2", args: "2>&1", exit_status: 1)
      out = out.gsub(__dir__, '')

      out.should == <<-MSG
/fixtures/backtrace.rb:2:in `a': unhandled exception
\tfrom /fixtures/backtrace.rb:6:in `b'
\tfrom /fixtures/backtrace.rb:10:in `c'
\t ... 2 levels...
      MSG
    end
  end
end
