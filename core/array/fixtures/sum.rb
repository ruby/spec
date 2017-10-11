module ArraySpec
  module AdditionIsOverriden
    module M
      refine Integer do
        def +(*args)
          raise "Redefined method is called"
        end
      end
    end

    using M

    def self.call_sum
      [1, 2, 3].sum
    end

    def self.call_explicit_adding
      1 + 2 + 3
    end
  end
end

