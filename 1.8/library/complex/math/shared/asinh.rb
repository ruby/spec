require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_asinh do |obj|
  describe "Math#{obj == Math ? '.' : '#'}asinh" do
  end
end

shared :complex_math_asinh_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}asinh!" do
  end
end