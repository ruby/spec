describe :integer_floor_precision, shared: true do
  context "precision is zero" do
    it "returns integer self" do
      send(@method, 0).floor(0).should.eql?(0)
      send(@method, 123).floor(0).should.eql?(123)
      send(@method, -123).floor(0).should.eql?(-123)
    end
  end

  context "precision is positive" do
    it "returns self" do
      send(@method, 0).floor(1).should.eql?(send(@method, 0))
      send(@method, 0).floor(10).should.eql?(send(@method, 0))

      send(@method, 123).floor(10).should.eql?(send(@method, 123))
      send(@method, -123).floor(10).should.eql?(send(@method, -123))
    end
  end

  context "precision is negative" do
    it "always returns 0 when self is 0" do
      send(@method, 0).floor(-1).should.eql?(0)
      send(@method, 0).floor(-10).should.eql?(0)
    end

    it "returns largest integer less than self with at least precision.abs trailing zeros" do
      send(@method, 123).floor(-1).should.eql?(120)
      send(@method, 123).floor(-2).should.eql?(100)
      send(@method, 123).floor(-3).should.eql?(0)

      send(@method, -123).floor(-1).should.eql?(-130)
      send(@method, -123).floor(-2).should.eql?(-200)
      send(@method, -123).floor(-3).should.eql?(-1000)
    end
  end
end
