require File.dirname(__FILE__) + '/../../shared/rational/quo'

ruby_version_is "1.9" do
  describe "Rational#quo" do
    it_behaves_like(:rational_quo, :quo)
  end
end
