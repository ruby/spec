require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/arithmetic_coerce', __FILE__)

ruby_version_is "2.4" do
  describe "Integer#/" do
    ruby_version_is "2.4"..."2.5" do
      it_behaves_like :integer_arithmetic_coerce_rescue, :/
    end

    ruby_version_is "2.5" do
      it_behaves_like :integer_arithmetic_coerce_not_rescue, :/
    end
  end
end

