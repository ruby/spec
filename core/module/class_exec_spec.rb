require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/class_exec', __FILE__)

ruby_version_is "1.8.7" do
  describe "Module#class_exec" do
    it_behaves_like :module_class_exec, :class_exec
  end
end
