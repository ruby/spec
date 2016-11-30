require File.expand_path('../spec_helper', __FILE__)

process_is_foreground do
  with_feature :readline do
    describe "Readline.readline" do
      before :each do
        @file = tmp('readline')
        touch(@file) { |f|
          f.puts "test"
        }
      end

      after :each do
        rm_r @file
      end

      # Somehow those specs block on Windows
      platform_is_not :windows do
        it "returns the input string" do
          out = ruby_exe('puts Readline.readline', options: "-rreadline", args: "< #{@file}")
          out.should =~ /^test\Z/
        end

        it "taints the returned strings" do
          out = ruby_exe('puts Readline.readline.tainted?', options: "-rreadline", args: "< #{@file}")
          out.should =~ /^true\Z/
        end
      end
    end
  end
end
