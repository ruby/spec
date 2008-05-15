require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_atan2 do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atan2" do
  end
end

shared :complex_math_atan2_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}atan2!" do
  end
end