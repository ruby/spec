require File.dirname(__FILE__) + '/caller_fixture2'
2 + 2
3 + 3
CallerFixture.capture do
  5 + 5
  6 + 6
  :seven
  8 + 8
end

module CallerFixture
  def example_proc
    Proc.new do
      1 + 1
      2 + 2
    end
  end
  module_function :example_proc
end
