require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_asin do |obj|
  describe "Math#{obj == Math ? '.' : '#'}asin" do
  end
end

shared :complex_math_asin_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}asin!" do
  end
end