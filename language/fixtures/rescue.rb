module RescueSpecs
  def self.begin_else(raise_exception, scratch_pad)
    begin
      scratch_pad << :one
      raise "an error occurred" if raise_exception
    rescue
      scratch_pad << :rescue_ran
      :rescue_val
    else
      scratch_pad << :else_ran
      :val
    end
  end
end
