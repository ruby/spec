require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/append', __FILE__)

describe "Array#push" do
  it_behaves_like(:array_append, :push)
end
