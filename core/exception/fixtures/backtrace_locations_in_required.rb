[:test].map do
  puts Thread.current.backtrace_locations[1].label
end
