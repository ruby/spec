require_relative '../../spec_helper'

ruby_version_is "3.0" do
  describe "GC.auto_compact" do
    guard -> { defined?(Etc::SC_PAGE_SIZE) && GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE] % Etc.sysconf(Etc::SC_PAGE_SIZE) == 0 } do
      before :each do
        @default = GC.auto_compact
      end

      after :each do
        GC.auto_compact = @default
      end

      it "can set and get a boolean value" do
        original = GC.auto_compact
        GC.auto_compact = !original
        GC.auto_compact.should == !original
      end
    end
  end
end
