require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is '2.4' do
  describe 'Enumerable#uniq'do
    before :each do
      @enum = Object.new.to_enum
      class << @enum
        def each
          yield 0, 'foo'
          yield 1, 'FOO'
          yield 2, 'bar'
        end
      end
    end

    it 'returns an array that contains only unique result of the given block' do
      @enum.uniq { |_, label| label.downcase }.should == [0, 2]
    end
  end
end
