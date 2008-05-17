shared :integer_to_i do |cmd|
  describe "Integer##{cmd}" do
    it "returns self" do
      10.send(cmd).eql?(10).should == true
      (-15).send(cmd).eql?(-15).should == true
      bignum_value.send(cmd).eql?(bignum_value).should == true
      (-bignum_value).send(cmd).eql?(-bignum_value).should == true
    end
  end
end
