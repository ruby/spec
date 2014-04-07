describe :proc_to_s, :shared => true do
  it "returns a description of self" do
    def hello; end

    Proc.new { "hello" }.send(@method).should =~ /^#<Proc:([^ ]*?)@([^ ]*)\/to_s\.rb:17>$/
    lambda { "hello" }.send(@method).should =~ /^#<Proc:([^ ]*?)@([^ ]*)\/to_s\.rb:18 \(lambda\)>$/
    proc { "hello" }.send(@method).should =~ /^#<Proc:([^ ]*?)@([^ ]*)\/to_s\.rb:19>$/
    method("hello").to_proc.send(@method).should =~ /^#<Proc:([^ ]*?)@([^ ]*)\/to_s\.rb:15 \(lambda\)>$/
  end
end
