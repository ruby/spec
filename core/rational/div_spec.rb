require File.dirname(__FILE__) + '/../../shared/rational/div'

ruby_version_is "1.9" do
  describe "Rational#div" do
    it_behaves_like(:rational_div, :div)
  end
end
