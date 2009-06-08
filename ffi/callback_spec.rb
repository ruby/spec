require File.expand_path('../spec_helper', __FILE__)

module FFISpecs
  describe "Callback" do
  #  module LibC
  #    extend Library
  #    callback :qsort_cmp, [ :pointer, :pointer ], :int
  #    attach_function :qsort, [ :pointer, :int, :int, :qsort_cmp ], :int
  #  end
  #  it "arguments get passed correctly" do
  #    p = MemoryPointer.new(:int, 2)
  #    p.put_array_of_int32(0, [ 1 , 2 ])
  #    args = []
  #    cmp = proc do |p1, p2| args.push(p1.get_int(0)); args.push(p2.get_int(0)); 0; end
  #    # this is a bit dodgey, as it relies on qsort passing the args in order
  #    LibC.qsort(p, 2, 4, cmp)
  #    args.should == [ 1, 2 ]
  #  end
  #
  #  it "Block can be substituted for Callback as last argument" do
  #    p = MemoryPointer.new(:int, 2)
  #    p.put_array_of_int32(0, [ 1 , 2 ])
  #    args = []
  #    # this is a bit dodgey, as it relies on qsort passing the args in order
  #    LibC.qsort(p, 2, 4) do |p1, p2|
  #      args.push(p1.get_int(0))
  #      args.push(p2.get_int(0))
  #      0
  #    end
  #    args.should == [ 1, 2 ]
  #  end

    it "function with Callback plus another arg should raise error if no arg given" do
      lambda { LibTest.testCallbackCrV { |*a| } }.should raise_error
    end

    it "returning :char (0)" do
      LibTest.testCallbackVrS8 { 0 }.should == 0
    end

    it "returning :char (127)" do
      LibTest.testCallbackVrS8 { 127 }.should == 127
    end

    it "returning :char (-128)" do
      LibTest.testCallbackVrS8 { -128 }.should == -128
    end

    # test wrap around
    it "returning :char (128)" do
      LibTest.testCallbackVrS8 { 128 }.should == -128
    end

    it "returning :char (255)" do
      LibTest.testCallbackVrS8 { 0xff }.should == -1
    end

    it "returning :uchar (0)" do
      LibTest.testCallbackVrU8 { 0 }.should == 0
    end

    it "returning :uchar (0xff)" do
      LibTest.testCallbackVrU8 { 0xff }.should == 0xff
    end

    it "returning :uchar (-1)" do
      LibTest.testCallbackVrU8 { -1 }.should == 0xff
    end

    it "returning :uchar (128)" do
      LibTest.testCallbackVrU8 { 128 }.should == 128
    end

    it "returning :uchar (-128)" do
      LibTest.testCallbackVrU8 { -128 }.should == 128
    end

    it "returning :short (0)" do
      LibTest.testCallbackVrS16 { 0 }.should == 0
    end

    it "returning :short (0x7fff)" do
      LibTest.testCallbackVrS16 { 0x7fff }.should == 0x7fff
    end

    # test wrap around
    it "returning :short (0x8000)" do
      LibTest.testCallbackVrS16 { 0x8000 }.should == -0x8000
    end

    it "returning :short (0xffff)" do
      LibTest.testCallbackVrS16 { 0xffff }.should == -1
    end

    it "returning :ushort (0)" do
      LibTest.testCallbackVrU16 { 0 }.should == 0
    end

    it "returning :ushort (0x7fff)" do
      LibTest.testCallbackVrU16 { 0x7fff }.should == 0x7fff
    end

    it "returning :ushort (0x8000)" do
      LibTest.testCallbackVrU16 { 0x8000 }.should == 0x8000
    end

    it "returning :ushort (0xffff)" do
      LibTest.testCallbackVrU16 { 0xffff }.should == 0xffff
    end

    it "returning :ushort (-1)" do
      LibTest.testCallbackVrU16 { -1 }.should == 0xffff
    end

    it "returning :int (0)" do
      LibTest.testCallbackVrS32 { 0 }.should == 0
    end

    it "returning :int (0x7fffffff)" do
      LibTest.testCallbackVrS32 { 0x7fffffff }.should == 0x7fffffff
    end

    # test wrap around
    it "returning :int (-0x80000000)" do
      LibTest.testCallbackVrS32 { -0x80000000 }.should == -0x80000000
    end

    it "returning :int (-1)" do
      LibTest.testCallbackVrS32 { -1 }.should == -1
    end

    it "returning :uint (0)" do
      LibTest.testCallbackVrU32 { 0 }.should == 0
    end

    it "returning :uint (0x7fffffff)" do
      LibTest.testCallbackVrU32 { 0x7fffffff }.should == 0x7fffffff
    end

    # test wrap around
    it "returning :uint (0x80000000)" do
      LibTest.testCallbackVrU32 { 0x80000000 }.should == 0x80000000
    end

    it "returning :uint (0xffffffff)" do
      LibTest.testCallbackVrU32 { 0xffffffff }.should == 0xffffffff
    end

    it "Callback returning :uint (-1)" do
      LibTest.testCallbackVrU32 { -1 }.should == 0xffffffff
    end

    it "returning :long (0)" do
      LibTest.testCallbackVrL { 0 }.should == 0
    end

    it "returning :long (0x7fffffff)" do
      LibTest.testCallbackVrL { 0x7fffffff }.should == 0x7fffffff
    end

    # test wrap around
    it "returning :long (-0x80000000)" do
      LibTest.testCallbackVrL { -0x80000000 }.should == -0x80000000
    end

    it "returning :long (-1)" do
      LibTest.testCallbackVrL { -1 }.should == -1
    end

    it "returning :ulong (0)" do
      LibTest.testCallbackVrUL { 0 }.should == 0
    end

    it "returning :ulong (0x7fffffff)" do
      LibTest.testCallbackVrUL { 0x7fffffff }.should == 0x7fffffff
    end

    # test wrap around
    it "returning :ulong (0x80000000)" do
      LibTest.testCallbackVrUL { 0x80000000 }.should == 0x80000000
    end

    it "returning :ulong (0xffffffff)" do
      LibTest.testCallbackVrUL { 0xffffffff }.should == 0xffffffff
    end

    it "Callback returning :ulong (-1)" do
      LibTest.testCallbackVrUL { -1 }.should == 0xffffffff
    end

    it "returning :long_long (0)" do
      LibTest.testCallbackVrS64 { 0 }.should == 0
    end

    it "returning :long_long (0x7fffffffffffffff)" do
      LibTest.testCallbackVrS64 { 0x7fffffffffffffff }.should == 0x7fffffffffffffff
    end

    # test wrap around
    it "returning :long_long (-0x8000000000000000)" do
      LibTest.testCallbackVrS64 { -0x8000000000000000 }.should == -0x8000000000000000
    end

    it "returning :long_long (-1)" do
      LibTest.testCallbackVrS64 { -1 }.should == -1
    end

    it "returning :pointer (nil)" do
      LibTest.testCallbackVrP { nil }.null?.should be_true
    end

    it "returning :pointer (MemoryPointer)" do
      p = MemoryPointer.new :long
      LibTest.testCallbackVrP { p }.should == p
    end

    it "global variable" do
      proc = Proc.new { 0x1e }
      LibTest.cbVrS8 = proc
      LibTest.testGVarCallbackVrS8(LibTest.pVrS8).should == 0x1e
    end

    describe "When the callback is considered optional by the underlying library" do
      it "should handle receiving 'nil' in place of the closure" do
        lambda { LibTest.testOptionalCallbackCrV(nil, 13) }.should_not raise_error
      end
    end

    describe 'when inlined' do
      it 'could be anonymous' do
        LibTest.testCallbackVrS8 { 0 }.should == 0
      end
    end

    describe "as return value" do
      it "should not blow up when a callback is defined that returns a callback" do
        lambda {
          LibTest.module_eval do
            callback :cb_return_type_1, [ :short ], :short
            callback :cb_lookup_1, [ :short ], :cb_return_type_1
            attach_function :testReturnsCallback_1, :testReturnsClosure, [ :cb_lookup_1, :short ], :cb_return_type_1
          end
        }.should_not raise_error
      end

      it "should return a callback" do
        lookup_proc_called = false
        return_proc_called = false

        return_proc = Proc.new do |a|
          return_proc_called = true
          a * 2
        end
        lookup_proc = Proc.new do
          lookup_proc_called = true
          return_proc
        end

        val = LibTest.testReturnsCallback(lookup_proc, 0x1234)
        val.should == 0x1234 * 2
        lookup_proc_called.should be_true
        return_proc_called.should be_true
      end

      it 'should not blow up when a callback takes a callback as argument' do
        lambda {
          LibTest.module_eval do
            callback :cb_argument, [ :int ], :int
            callback :cb_with_cb_argument, [ :cb_argument, :int ], :int
            attach_function :testCallbackAsArgument, :testArgumentClosure, [ :cb_with_cb_argument, :int ], :int
          end
        }.should_not raise_error
      end

      it 'should be able to use the callback argument' do
        # TODO: Moving this to fixtures/classes.rb breaks
        module LibTest
          callback :cb_argument, [ :int ], :int
          callback :cb_with_cb_argument, [ :cb_argument, :int ], :int
          attach_function :testCallbackAsArgument, :testArgumentClosure, [ :cb_with_cb_argument, :cb_argument, :int ], :int
        end

        callback_arg_called = false
        callback_with_callback_arg_called = false

        callback_arg = Proc.new do |val|
          callback_arg_called = true
          val * 2
        end
        callback_with_callback_arg = Proc.new do |cb, val|
          callback_with_callback_arg_called = true
          cb.call(val)
        end

        val = LibTest.testCallbackAsArgument(callback_with_callback_arg, callback_arg, 0xff1)

        val.should == 0xff1 * 2
        callback_arg_called.should be_true
        callback_with_callback_arg_called.should be_true
      end

      it 'function returns callable object' do
        f = LibTest.testReturnsFunctionPointer
        f.call(3).should == 6
      end
    end
  end

  describe "primitive argument" do
    it ":char (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackCrV(0) { |i| v = i }
      v.should == 0
    end

    it ":char (127) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackCrV(127) { |i| v = i }
      v.should == 127
    end

    it ":char (-128) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackCrV(-128) { |i| v = i }
      v.should == -128
    end

    it ":char (-1) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackCrV(-1) { |i| v = i }
      v.should == -1
    end

    it ":uchar (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU8rV(0) { |i| v = i }
      v.should == 0
    end

    it ":uchar (127) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU8rV(127) { |i| v = i }
      v.should == 127
    end

    it ":uchar (128) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU8rV(128) { |i| v = i }
      v.should == 128
    end

    it ":uchar (255) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU8rV(255) { |i| v = i }
      v.should == 255
    end

    it ":short (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackSrV(0) { |i| v = i }
      v.should == 0
    end

    it ":short (0x7fff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackSrV(0x7fff) { |i| v = i }
      v.should == 0x7fff
    end

    it ":short (-0x8000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackSrV(-0x8000) { |i| v = i }
      v.should == -0x8000
    end

    it ":short (-1) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackSrV(-1) { |i| v = i }
      v.should == -1
    end

    it ":ushort (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU16rV(0) { |i| v = i }
      v.should == 0
    end

    it ":ushort (0x7fff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU16rV(0x7fff) { |i| v = i }
      v.should == 0x7fff
    end

    it ":ushort (0x8000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU16rV(0x8000) { |i| v = i }
      v.should == 0x8000
    end

    it ":ushort (0xffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU16rV(0xffff) { |i| v = i }
      v.should == 0xffff
    end

    it ":int (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackIrV(0) { |i| v = i }
      v.should == 0
    end

    it ":int (0x7fffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackIrV(0x7fffffff) { |i| v = i }
      v.should == 0x7fffffff
    end

    it ":int (-0x80000000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackIrV(-0x80000000) { |i| v = i }
      v.should == -0x80000000
    end

    it ":int (-1) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackIrV(-1) { |i| v = i }
      v.should == -1
    end

    it ":uint (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU32rV(0) { |i| v = i }
      v.should == 0
    end

    it ":uint (0x7fffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU32rV(0x7fffffff) { |i| v = i }
      v.should == 0x7fffffff
    end

    it ":uint (0x80000000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU32rV(0x80000000) { |i| v = i }
      v.should == 0x80000000
    end

    it ":uint (0xffffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackU32rV(0xffffffff) { |i| v = i }
      v.should == 0xffffffff
    end

    it ":long (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLrV(0) { |i| v = i }
      v.should == 0
    end

    it ":long (0x7fffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLrV(0x7fffffff) { |i| v = i }
      v.should == 0x7fffffff
    end

    it ":long (-0x80000000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLrV(-0x80000000) { |i| v = i }
      v.should == -0x80000000
    end

    it ":long (-1) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLrV(-1) { |i| v = i }
      v.should == -1
    end

    it ":ulong (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackULrV(0) { |i| v = i }
      v.should == 0
    end

    it ":ulong (0x7fffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackULrV(0x7fffffff) { |i| v = i }
      v.should == 0x7fffffff
    end

    it ":ulong (0x80000000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackULrV(0x80000000) { |i| v = i }
      v.should == 0x80000000
    end

    it ":ulong (0xffffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackULrV(0xffffffff) { |i| v = i }
      v.should == 0xffffffff
    end

    it ":long_long (0) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLLrV(0) { |i| v = i }
      v.should == 0
    end

    it ":long_long (0x7fffffffffffffff) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLLrV(0x7fffffffffffffff) { |i| v = i }
      v.should == 0x7fffffffffffffff
    end

    it ":long_long (-0x8000000000000000) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLLrV(-0x8000000000000000) { |i| v = i }
      v.should == -0x8000000000000000
    end

    it ":long_long (-1) argument" do
      v = 0xdeadbeef
      LibTest.testCallbackLLrV(-1) { |i| v = i }
      v.should == -1
    end
  end
end