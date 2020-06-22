module RescueSpecs
  class ClassVariableCaptor
    def capture(msg)
      raise msg
    rescue => @@captured_error
      :caught
    end

    def captured_error
      self.class.remove_class_variable(:@@captured_error)
    end
  end

  class ConstantCaptor
    # Using lambda gets around the dynamic constant assignment warning
    CAPTURE = -> msg {
      begin
        raise msg
      rescue => CapturedError
        :caught
      end
    }

    def capture(msg)
      CAPTURE.call(msg)
    end

    def captured_error
      self.class.send(:remove_const, :CapturedError)
    end
  end

  class GlobalVariableCaptor
    def capture(msg)
      raise msg
    rescue => $captured_error
      :caught
    end

    def captured_error
      $captured_error.tap do
        $captured_error = nil # Can't remove globals, only nil them out
      end
    end
  end

  class InstanceVariableCaptor
    attr_reader :captured_error

    def capture(msg)
      raise msg
    rescue => @captured_error
      :caught
    end
  end

  class LocalVariableCaptor
    attr_reader :captured_error

    def capture(msg)
      raise msg
    rescue => captured_error
      @captured_error = captured_error
      :caught
    end
  end

  class SafeNavigationSetterCaptor
    attr_accessor :captured_error

    def capture(msg)
      raise msg
    rescue => self&.captured_error
      :caught
    end
  end

  class SetterCaptor
    attr_accessor :captured_error

    def capture(msg)
      raise msg
    rescue => self.captured_error
      :caught
    end
  end

  class SquareBracketsCaptor
    def capture(msg)
      @hash = {}

      raise msg
    rescue => self[:error]
      :caught
    end

    def []=(key, value)
      @hash[key] = value
    end

    def captured_error
      @hash[:error]
    end
  end

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

  def self.begin_else_ensure(raise_exception)
    begin
      ScratchPad << :one
      raise "an error occurred" if raise_exception
    rescue
      ScratchPad << :rescue_ran
      :rescue_val
    else
      ScratchPad << :else_ran
      :val
    ensure
      ScratchPad << :ensure_ran
      :ensure_val
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

  def self.begin_else_return_ensure(raise_exception)
    begin
      ScratchPad << :one
      raise "an error occurred" if raise_exception
    rescue
      ScratchPad << :rescue_ran
      :rescue_val
    else
      ScratchPad << :else_ran
      :val
    ensure
      ScratchPad << :ensure_ran
      :ensure_val
    end
    ScratchPad << :outside_begin
    :return_val
  end

  def self.raise_standard_error
    raise StandardError, "an error occurred"
  end
end
