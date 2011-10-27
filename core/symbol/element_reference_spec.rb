require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes.rb', __FILE__)
require File.expand_path('../shared/slice.rb', __FILE__)

ruby_version_is "1.9" do
  describe "Symbol#[]" do
    it_behaves_like :symbol_slice, :[]
  end

  describe "Symbol#[] with index, length" do
    it_behaves_like :symbol_slice_index_length, :[]
  end

  describe "Symbol#[] with Range" do
    it_behaves_like :symbol_slice_range, :[]
  end

  describe "Symbol#[] with Regexp" do
    it_behaves_like :symbol_slice_regexp, :[]
  end

  describe "Symbol#[] with Regexp, index" do
    it_behaves_like :symbol_slice_regexp_index, :[]
  end

  describe "Symbol#[] with String" do
    it_behaves_like :symbol_slice_string, :[]
  end
end