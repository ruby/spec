require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_acosh do |obj|
  describe "Math#{obj == Math ? '.' : '#'}acosh" do
  end
end

shared :complex_math_acosh_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}acosh!" do
  end
end