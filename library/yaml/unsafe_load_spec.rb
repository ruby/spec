require_relative '../../spec_helper'
require_relative 'fixtures/common'
require_relative 'fixtures/strings'
require_relative 'shared/unsafe_load'

guard -> { Psych::VERSION >= "4.0.0" } do
  describe "YAML.unsafe_load" do
    it_behaves_like :yaml_unsafe_load, :unsafe_load
  end
end
