require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/to_i', __FILE__)

describe "Integer#truncate" do
  it_behaves_like(:integer_to_i, :truncate)

  ruby_version_is "2.4" do
    context "precision argument specified as part of the truncate method is zero or positive" do
      it "returns self as integer or float" do
        1.truncate.should eql(1)
        1.truncate(0).should eql(1)
        1.truncate(2).should eql(1.0)
        1832.truncate(3).should eql(1832.0)
        -1832.truncate(3).should eql(-1832.0)
      end
    end

    context "precision argument specified as part of the truncate method is negative" do
      it "returns an integer with at least precision.abs trailing zeros" do
        1832.truncate(-1).should eql(1830)
        1832.truncate(-2).should eql(1800)
        1832.truncate(-3).should eql(1000)
        -1832.truncate(-1).should eql(-1830)
        -1832.truncate(-2).should eql(-1800)
        -1832.truncate(-3).should eql(-1000)
      end
    end
  end
end
