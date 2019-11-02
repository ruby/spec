require_relative '../../spec_helper'

describe "Exception" do
  it "has the right class hierarchy" do
    def save_pairs(parent, hash, pairs)
      hash.each do |key, value|
        pairs.push [parent, key]
        if value.is_a?(Hash)
          save_pairs(key, value, pairs)
        end
      end
    end
    hierarchy = {
        Exception => {
            NoMemoryError => nil,
            ScriptError => {
                LoadError => nil,
                NotImplementedError => nil,
                SyntaxError => nil,
            },
            SecurityError => nil,
            SignalException => {
                Interrupt => nil,
            },
            StandardError => {
                ArgumentError => {
                    UncaughtThrowError => nil,
                },
                EncodingError => nil,
                FiberError => nil,
                IOError => {
                    EOFError => nil,
                },
                IndexError => {
                    KeyError => nil,
                    StopIteration => {
                        ClosedQueueError => nil,
                    },
                },
                LocalJumpError => nil,
                NameError => {
                    NoMethodError => nil,
                },
                RangeError => {
                    FloatDomainError => nil,
                },
                RegexpError => nil,
                RuntimeError => nil,
                SystemCallError => nil,
            ThreadError => nil,
            TypeError => nil,
            ZeroDivisionError => nil,
            },
        SystemExit => nil,
        SystemStackError => nil,
        },
    }
    ruby_version_is "2.7" do
      hierarchy[Exception][StandardError][RuntimeError] = {FrozenError => nil}
    end
    pairs = []
    save_pairs(Object, hierarchy, pairs)
    pairs.each do |pair|
      this_class, sub_class = *pair
      sub_class.class.should == Class
      sub_class.superclass.should == this_class
    end
  end
end
