require File.dirname(__FILE__) + '/../../spec_helper'

describe "ARGF.gets" do
  before :each do
    @file1_name = fixture __FILE__, "file1.txt"
    @file2_name = fixture __FILE__, "file2.txt"
    @stdin_name = fixture __FILE__, "stdin.txt"

    @file1 = File.readlines @file1_name
    @file2 = File.readlines @file2_name
    @stdin = File.read @stdin_name
  end

  after :each do
    ARGF.close
  end

  it "reads one line of a file" do
    argv [@file1_name] do
      ARGF.gets.should == @file1.first
    end
  end

  it "reads all lines of a file" do
    argv [@file1_name] do
      lines = []
      @file1.size.times { lines << ARGF.gets }
      lines.should == @file1
    end
  end

  it "reads all lines of stdin" do
    stdin = ruby_exe("while line = ARGF.gets do print line end",
                     :args => "< #{@stdin_name}")
    stdin.should == @stdin
  end

  it "reads all lines of two files" do
    argv [@file1_name, @file2_name] do
      total = @file1.size + @file2.size
      lines = []
      total.times { lines << ARGF.gets }
      lines.should == @file1 + @file2
    end
  end

  it "returns nil when reaching end of files" do
    argv [@file1_name, @file2_name] do
      total = @file1.size + @file2.size
      total.times { ARGF.gets }
      ARGF.gets.should == nil
    end
  end

  it "sets $_ global variable with each line read" do
    argv [@file1_name, @file2_name] do
      while line = ARGF.gets
        $_.should == line
      end
    end
  end
end

describe "ARGF.gets" do
  before :each do
    @file1_name = fixture __FILE__, "file1.txt"
    @file2_name = fixture __FILE__, "file2.txt"

    @tmp1_name  = tmp "file1.txt"
    @tmp2_name  = tmp "file2.txt"

    @tmp1_name_bak = @tmp1_name + ".bak"
    @tmp2_name_bak = @tmp2_name + ".bak"

    FileUtils.cp @file1_name, @tmp1_name
    FileUtils.cp @file2_name, @tmp2_name
  end

  after :each do
    File.delete @tmp1_name if File.exists? @tmp1_name
    File.delete @tmp2_name if File.exists? @tmp2_name

    File.delete @tmp1_name_bak if File.exists? @tmp1_name_bak
    File.delete @tmp2_name_bak if File.exists? @tmp2_name_bak
  end

  it "modifies the files when in place edit mode is on" do
    ruby_exe("while line = ARGF.gets do puts 'x' end",
             :options => "-i",
             :args => "#{@tmp1_name} #{@tmp2_name}")

    File.read(@tmp1_name).should == "x\nx\n"
    File.read(@tmp2_name).should == "x\nx\n"
  end

  it "modifies and backups two files when in place edit mode is on" do
    ruby_exe("while line = ARGF.gets do puts 'x' end",
             :options => "-i.bak",
             :args => "#{@tmp1_name} #{@tmp2_name}")

    File.read(@tmp1_name).should == "x\nx\n"
    File.read(@tmp2_name).should == "x\nx\n"

    File.read(@tmp1_name_bak).should == "file1.1\nfile1.2\n"
    File.read(@tmp2_name_bak).should == "line2.1\nline2.2\n"
  end
end
