module CoverageSpecs
  # Clear old results from the result hash
  # https://bugs.ruby-lang.org/issues/12220
  def self.filtered_result
    result = Coverage.result
    result
  end
end
