require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is '2.4' do
    describe "Float#dup" do
        it "returns self" do
            2.4.dup.should equal(2.4)
        end
    end
end
