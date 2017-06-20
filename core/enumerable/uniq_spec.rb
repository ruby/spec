require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is '2.4' do
  describe 'Enumerable#uniq'do
    it 'returns an array that contains only unique elements' do
      [0, 1, 2, 3].to_enum.uniq { |n| n.even? }.should == [0, 1]
    end
  end
end
