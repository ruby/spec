describe :proc_compose, shared: true do
  it "raises NoMethodError if passed not callable object" do
    not_callable = Object.new
    composed = @object.call.send(@method, not_callable)

    -> {
      composed.call('a')
    }.should raise_error(NoMethodError, /undefined method `call' for/)

  end

  it "does not try to coerce argument with #to_proc" do
    succ = Object.new
    def succ.to_proc(s); s.succ; end

    composed = @object.call.send(@method, succ)

    -> {
      composed.call('a')
    }.should raise_error(NoMethodError, /undefined method `call' for/)
  end
end
