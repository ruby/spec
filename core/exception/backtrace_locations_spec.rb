require_relative '../../spec_helper'
require_relative 'fixtures/common'

describe "Exception#backtrace_locations" do
  before :each do
    @backtrace = ExceptionSpecs::Backtrace.backtrace_locations
  end

  it "returns nil if no backtrace was set" do
    Exception.new.backtrace_locations.should be_nil
  end

  it "returns an Array" do
    @backtrace.should be_an_instance_of(Array)
  end

  it "sets each element to a Thread::Backtrace::Location" do
    @backtrace.each {|l| l.should be_an_instance_of(Thread::Backtrace::Location)}
  end

  it "produces a backtrace for an exception captured using $!" do
    exception = begin
      raise
    rescue RuntimeError
      $!
    end

    exception.backtrace_locations.first.path.should =~ /backtrace_locations_spec/
  end

  it "returns an Array that can be updated" do
    begin
      raise
    rescue RuntimeError => e
      e.backtrace_locations.unshift "backtrace first"
      e.backtrace_locations[0].should == "backtrace first"
    end
  end

  it "includes the nesting level of a block as part of the backtrace label" do
    first_level_location, second_level_location, third_level_location =
      ExceptionSpecs::Backtrace.backtrace_locations_inside_nested_blocks

    first_level_location.label.should == 'block in backtrace_locations_inside_nested_blocks'
    second_level_location.label.should == 'block (2 levels) in backtrace_locations_inside_nested_blocks'
    third_level_location.label.should == 'block (3 levels) in backtrace_locations_inside_nested_blocks'
  end

  it "sets the backtrace label for a top-level block differently depending on it being in the main file or a required file" do
    path = fixture(__FILE__, "backtrace_locations_in_main.rb")
    main_label, required_label = ruby_exe(path).lines

    main_label.strip.should == 'block in <main>'
    required_label.strip.should == 'block in <top (required)>'
  end
end
