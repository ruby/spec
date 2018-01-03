require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/exponent', __FILE__)

ruby_version_is '2.4' do
  describe "Integer#**" do
    it_behaves_like :integer_exponent, :**
  end
end
