module CoverageSpecs
  module SpecHelper
    # Clear old results from the result hash
    # https://bugs.ruby-lang.org/issues/12220
    def filtered_result
      Coverage.result.select { |_k, v| v.any? }
    end
  end
end
