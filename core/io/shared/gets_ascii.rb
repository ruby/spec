# encoding: ASCII
describe :io_gets_ascii, :shared => true do
  describe "with ASCII separator" do
    before :each do
      File.open(tmp("gets_specs"), "wb") do |file|
        file.print("this is a test\xFFit is only a test\ndoes it work?")
      end

      File.open(tmp("gets_specs"), "rb") do |file|
        @gets = file.gets("\xFF")
      end
    end

    after :each do
      File.unlink(tmp("gets_specs"))
    end

    ruby_version_is ""..."1.9" do
      it "returns the separator's number representation" do
        @gets.should == "this is a test\377"
      end
    end

    ruby_version_is "1.9" do
      it "returns the separator's character representation" do
        @gets.should == "this is a test\xFF"
      end
    end
  end
end
