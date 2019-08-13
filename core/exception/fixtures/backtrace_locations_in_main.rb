[:test].map do
  puts Thread.current.backtrace_locations[1].label
end

require_relative 'backtrace_locations_in_required'
