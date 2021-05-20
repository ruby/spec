describe :yaml_unsafe_load, shared: true do
  after :each do
    rm_r $test_file
  end

  it "works on complex keys" do
    require 'date'
    expected = {
        [ 'Detroit Tigers', 'Chicago Cubs' ] => [ Date.new( 2001, 7, 23 ) ],
        [ 'New York Yankees', 'Atlanta Braves' ] => [ Date.new( 2001, 7, 2 ),
                                                      Date.new( 2001, 8, 12 ),
                                                      Date.new( 2001, 8, 14 ) ]
    }
    YAML.send(@method, $complex_key_1).should == expected
  end

  describe "with iso8601 timestamp" do
    it "computes the microseconds" do
      [ [YAML.send(@method, "2011-03-22t23:32:11.2233+01:00"),   223300],
        [YAML.send(@method, "2011-03-22t23:32:11.0099+01:00"),   9900],
        [YAML.send(@method, "2011-03-22t23:32:11.000076+01:00"), 76]
      ].should be_computed_by(:usec)
    end

    it "rounds values smaller than 1 usec to 0 " do
      YAML.send(@method, "2011-03-22t23:32:11.000000342222+01:00").usec.should == 0
    end
  end

  it "loads an OpenStruct" do
    require "ostruct"
    os = OpenStruct.new("age" => 20, "name" => "John")
    loaded = YAML.send(@method, "--- !ruby/object:OpenStruct\ntable:\n  :age: 20\n  :name: John\n")
    loaded.should == os
  end

  it "loads a File but raise an error when used as it is uninitialized" do
    loaded = YAML.send(@method, "--- !ruby/object:File {}\n")
    -> {
      loaded.read(1)
    }.should raise_error(IOError)
  end
end