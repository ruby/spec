require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_atan do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atan" do
  end
end

shared :complex_math_atan_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atan!" do
  end
end