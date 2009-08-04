require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "File.world_writable?" do
    
    before(:each) do
      @file = tmp('world-writable')
      File.open(@file,'w') {|f| f.puts }
    end
    
    after(:each) do
      File.unlink(@file) if File.exists?(@file)
    end

    # These will surely fail on Windows.
    it "returns nil if the file is chmod 600" do
      File.chmod(0600, @file)
      File.world_writable?(@file).should be_nil
    end

    it "returns nil if the file is chmod 000" do
      File.chmod(0000, @file)
      File.world_writable?(@file).should be_nil
    end

    it "returns nil if the file is chmod 700" do
      File.chmod(0700, @file)
      File.world_writable?(@file).should be_nil
    end

    # We don't specify what the Fixnum is because it's system dependent
    it "returns a Fixnum if the file is chmod 777" do
      File.chmod(0777, @file)
      File.world_writable?(@file).should be_an_instance_of(Fixnum)
    end

    it "returns a Fixnum if the file is a directory and chmod 777" do
      dir = rand().to_s + '-ww'
      Dir.mkdir(dir)
      Dir.exists?(dir).should be_true
      File.chmod(0777, dir)
      File.world_writable?(dir).should be_an_instance_of(Fixnum)
      Dir.rmdir(dir)
    end

    it "returns nil if the file does not exist" do
      file = rand.to_s + $$.to_s
      File.exists?(file).should be_false
      File.world_writable?(file).should be_nil
    end

    it "coerces the argument with #to_path" do
      obj = mock('path')
      obj.should_receive(:to_path).and_return(@file)
      File.world_writable?(obj)
    end
  end
end
