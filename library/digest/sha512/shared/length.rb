require_relative 'constants'

describe :sha512_length, shared: true do
  it "returns the length of the digest" do
    @object.send(@method).should == SHA512Constants::BlankDigest.size
    @object << SHA512Constants::Contents
    @object.send(@method).should == SHA512Constants::Digest.size
  end
end
