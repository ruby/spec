require_relative '../../../spec_helper'
require_relative '../../../library/digest/sha1/shared/constants'
require_relative '../../../library/digest/sha256/shared/constants'
require_relative '../../../library/digest/sha384/shared/constants'
require_relative '../../digest/sha512/shared/length'
require 'openssl'

describe "OpenSSL::Digest#digest_length" do
  context "when the digest object is created via a name argument" do
    it "returns a SHA1 digest length" do
      OpenSSL::Digest.new('sha1').digest_length.should == SHA1Constants::DigestLength
    end

    it "returns a SHA256 digest length" do
      OpenSSL::Digest.new('sha256').digest_length.should == SHA256Constants::DigestLength
    end

    it "returns a SHA384 digest length" do
      OpenSSL::Digest.new('sha384').digest_length.should == SHA384Constants::DigestLength
    end

    it_behaves_like :sha512_length, :digest_length, OpenSSL::Digest.new('sha512')
  end

  context "when the digest object is created via a subclass" do
    it "returns a SHA1 digest length" do
      OpenSSL::Digest::SHA1.new.digest_length.should == SHA1Constants::DigestLength
    end

    it "returns a SHA256 digest length" do
      OpenSSL::Digest::SHA256.new.digest_length.should == SHA256Constants::DigestLength
    end

    it "returns a SHA384 digest length" do
      OpenSSL::Digest::SHA384.new.digest_length.should == SHA384Constants::DigestLength
    end

    it_behaves_like :sha512_length, :digest_length, OpenSSL::Digest::SHA512.new
  end
end
