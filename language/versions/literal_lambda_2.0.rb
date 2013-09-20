describe "->(){}" do
  it "allows a space between the -> and ()" do
    lambda { -> () {} }.should_not raise_error
  end
end
