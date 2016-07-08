module RescueSpecs
  def self.begin_else(raise_exception)
    begin
      ScratchPad << :one
      raise "an error occurred" if raise_exception
    rescue
      ScratchPad << :rescue_ran
      :rescue_val
    else
      ScratchPad << :else_ran
      :val
    end
  end

  def self.begin_else_return(raise_exception)
    begin
      ScratchPad << :one
      raise "an error occurred" if raise_exception
    rescue
      ScratchPad << :rescue_ran
      :rescue_val
    else
      ScratchPad << :else_ran
      :val
    end
    ScratchPad << :outside_begin
    :return_val
  end
end
