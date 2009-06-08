require File.expand_path('../spec_helper', __FILE__)

module FFISpecs
  describe "Function with primitive integer arguments" do
    it "int8.size" do
      TYPE_INT8.size.should == 1
    end

    it "uint8.size" do
      TYPE_UINT8.size.should == 1
    end

    it "int16.size" do
      TYPE_INT16.size.should == 2
    end

    it "uint16.size" do
      TYPE_UINT16.size.should == 2
    end

    it "int32.size" do
      TYPE_INT32.size.should == 4
    end

    it "uint32.size" do
      TYPE_UINT32.size.should == 4
    end

    it "int64.size" do
      TYPE_INT64.size.should == 8
    end

    it "uint64.size" do
      TYPE_UINT64.size.should == 8
    end

    it "float.size" do
      TYPE_FLOAT32.size.should == 4
    end

    it "double.size" do
      TYPE_FLOAT64.size.should == 8
    end

    [ 0, 127, -128, -1 ].each do |i|
      it ":char call(:char (#{i}))" do
        LibTest.ret_s8(i).should == i
      end
    end

    [ 0, 0x7f, 0x80, 0xff ].each do |i|
      it ":uchar call(:uchar (#{i}))" do
        LibTest.ret_u8(i).should == i
      end
    end

    [ 0, 0x7fff, -0x8000, -1 ].each do |i|
      it ":short call(:short (#{i}))" do
        LibTest.ret_s16(i).should == i
      end
    end

    [ 0, 0x7fff, 0x8000, 0xffff ].each do |i|
      it ":ushort call(:ushort (#{i}))" do
        LibTest.ret_u16(i).should == i
      end
    end

    [ 0, 0x7fffffff, -0x80000000, -1 ].each do |i|
      it ":int call(:int (#{i}))" do
        LibTest.ret_s32(i).should == i
      end
    end

    [ 0, 0x7fffffff, 0x80000000, 0xffffffff ].each do |i|
      it ":uint call(:uint (#{i}))" do
        LibTest.ret_u32(i).should == i
      end
    end

    [ 0, 0x7fffffffffffffff, -0x8000000000000000, -1 ].each do |i|
      it ":long_long call(:long_long (#{i}))" do
        LibTest.ret_s64(i).should == i
      end
    end

    [ 0, 0x7fffffffffffffff, 0x8000000000000000, 0xffffffffffffffff ].each do |i|
      it ":ulong_long call(:ulong_long (#{i}))" do
        LibTest.ret_u64(i).should == i
      end
    end
  
    if Platform::LONG_SIZE == 32
      [ 0, 0x7fffffff, -0x80000000, -1 ].each do |i|
        it ":long call(:long (#{i}))" do
          LibTest.ret_long(i).should == i
        end
      end

      [ 0, 0x7fffffff, 0x80000000, 0xffffffff ].each do |i|
        it ":ulong call(:ulong (#{i}))" do
          LibTest.ret_ulong(i).should == i
        end
      end
    else
      [ 0, 0x7fffffffffffffff, -0x8000000000000000, -1 ].each do |i|
        it ":long call(:long (#{i}))" do
          LibTest.ret_long(i).should == i
        end
      end

      [ 0, 0x7fffffffffffffff, 0x8000000000000000, 0xffffffffffffffff ].each do |i|
        it ":ulong call(:ulong (#{i}))" do
          LibTest.ret_ulong(i).should == i
        end
      end

      [ 0.0, 0.1, 1.1, 1.23 ].each do |f|
        it ":float call(:double (#{f}))" do
          LibTest.set_float(f)
          (LibTest.get_float - f).abs.should < 0.001
        end
      end

      [ 0.0, 0.1, 1.1, 1.23 ].each do |f|
        it ":double call(:double (#{f}))" do
          LibTest.set_double(f)
          (LibTest.get_double - f).abs.should < 0.001
        end
      end
    end
  end

  describe "Integer parameter range checking" do
    [ 128, -129 ].each do |i|
      it ":char call(:char (#{i}))" do
        lambda { LibTest.ret_int8_t(i).should == i }.should raise_error
      end
    end

    [ -1, 256 ].each do |i|
      it ":uchar call(:uchar (#{i}))" do
        lambda { LibTest.ret_u_int8_t(i).should == i }.should raise_error
      end
    end

    [ 0x8000, -0x8001 ].each do |i|
      it ":short call(:short (#{i}))" do
        lambda { LibTest.ret_int16_t(i).should == i }.should raise_error
      end
    end

    [ -1, 0x10000 ].each do |i|
      it ":ushort call(:ushort (#{i}))" do
        lambda { LibTest.ret_u_int16_t(i).should == i }.should raise_error
      end
    end

    [ 0x80000000, -0x80000001 ].each do |i|
      it ":int call(:int (#{i}))" do
        lambda { LibTest.ret_int32_t(i).should == i }.should raise_error
      end
    end

    [ -1, 0x100000000 ].each do |i|
      it ":ushort call(:ushort (#{i}))" do
        lambda { LibTest.ret_u_int32_t(i).should == i }.should raise_error
      end
    end
  end

  describe "Three different size Integer arguments" do
    def self.verify(p, off, t, v)
      if t == 'f32'
        p.get_float32(off).should == v
      elsif t == 'f64'
        p.get_float64(off).should == v
      else
        p.get_int64(off).should == v
      end
    end

    PACK_VALUES.keys.each do |t1|
      PACK_VALUES.keys.each do |t2|
        PACK_VALUES.keys.each do |t3|
          PACK_VALUES[t1].each do |v1|
            PACK_VALUES[t2].each do |v2|
              PACK_VALUES[t3].each do |v3|
                it "call(#{TYPE_MAP[t1]} (#{v1}), #{TYPE_MAP[t2]} (#{v2}), #{TYPE_MAP[t3]} (#{v3}))" do
                  p = Buffer.new :long_long, 3
                  LibTest.send("pack_#{t1}#{t2}#{t3}_s64", v1, v2, v3, p)
                  verify(p, 0, t1, v1)
                  verify(p, 8, t2, v2)
                  verify(p, 16, t3, v3)
                end
              end
            end
          end
        end
      end
    end
  end
end