# The propagation checked here is the LAZY_MEMO_PACKED bit traveling along the chain in CRuby.
describe :enumerator_lazy_packed_propagation, shared: true do
  # @stage: a Proc wrapping a lazy enumerator in the stage under test, e.g. -> e { e.take(12) }.

  before :each do
    @yieldsmixed = EnumeratorLazySpecs::YieldsMixed.new.to_enum.lazy
  end

  it "passes a multiple-argument source yield to a later stage's single-argument block as the first value" do
    yields = []
    @stage.call(@yieldsmixed).map { |v| yields << v }.force
    yields.should == EnumeratorLazySpecs::YieldsMixed.initial_yields
  end

  it "passes every value of a multiple-argument source yield to a later stage's splat block" do
    args = nil
    @stage.call(Enumerator.new { |y| y.yield 1, 2 }.lazy).map { |*a| args = a }.force
    args.should == [1, 2]
  end

  it "passes a zero-argument source yield on as a single nil" do
    args = nil
    @stage.call(Enumerator.new { |y| y.yield }.lazy).map { |*a| args = a }.force
    args.should == [nil]
  end

  it "stops propagating once a stage replaces the value" do
    yields = []
    @stage.call(Enumerator.new { |y| y.yield 1, 2 }.lazy).map { |x| x }.map { |*a| yields << a }.force
    yields.should == [[1]]
  end
end
