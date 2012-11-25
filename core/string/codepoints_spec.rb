require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/codepoints', __FILE__)

with_feature :encoding do
  ruby_version_is '1.8.7'...'2.0' do
    describe "String#codepoints" do
      it_behaves_like(:string_codepoints, :codepoints)
    end
  end
end
