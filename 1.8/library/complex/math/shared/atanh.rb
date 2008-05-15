require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_atanh do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atanh" do
  end
end

shared :complex_math_atanh_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atanh!" do
  end
end