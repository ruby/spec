require File.expand_path('../../../spec_helper', __FILE__)
require 'pp'

describe "PP.pp" do
  before :each do
    @original_stdout = $stdout
  end

  after :each do
    $stdout = @original_stdout
  end

  it 'works with default arguments' do
    array = [1, 2, 3]

    lambda {
      PP.pp array
    }.should output "[1, 2, 3]\n"
  end

  it 'allows specifying out explicitly' do
    $stdout = IOStub.new
    other_out = IOStub.new
    array = [1, 2, 3]

    PP.pp array, other_out

    other_out.to_s.should == "[1, 2, 3]\n"
    $stdout.to_s.should == ''
  end

  it "needs to be reviewed for spec completeness"
end
