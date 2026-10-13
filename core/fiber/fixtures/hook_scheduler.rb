module FiberSpecs
  # A minimal scheduler recording the hooks that were called, with an IO.select based event loop.
  class HookScheduler
    attr_reader :events

    def initialize
      @events = []
      @ready = []
      @waiting = {}
    end

    def run
      until @ready.empty? && @waiting.empty?
        while fiber = @ready.shift
          fiber.resume if fiber.alive?
        end

        next if @waiting.empty?
        readable = @waiting.select { |_, (events, _)| events & IO::READABLE != 0 }.keys
        writable = @waiting.select { |_, (events, _)| events & IO::WRITABLE != 0 }.keys
        r, w = IO.select(readable, writable, nil, 0.05)
        (r.to_a + w.to_a).uniq.each do |io|
          _, fiber = @waiting.delete(io)
          @ready << fiber
        end
      end
    end

    def close
      run
    end

    def fiber(&block)
      Fiber.new(blocking: false, &block).tap(&:resume)
    end

    def block(blocker, timeout = nil)
      Fiber.yield
    end

    def unblock(blocker, fiber)
      @ready << fiber
    end

    def kernel_sleep(duration = nil)
      @ready << Fiber.current
      Fiber.yield
    end

    def io_wait(io, events, timeout)
      @waiting[io] = [events, Fiber.current]
      Fiber.yield
      events
    end

    def fiber_interrupt(fiber, exception)
      @events << [:fiber_interrupt, fiber, exception]
      @waiting.delete_if { |_, (_, waiting_fiber)| waiting_fiber == fiber && @ready << fiber }
    end

    def io_close(io)
      @events << [:io_close, io]
      nil
    end

    def io_write(io, buffer, length, offset)
      @events << [:io_write, io, buffer.get_string]
      buffer.size
    end

    def events_named(name)
      @events.select { |event| event.first == name }
    end

    def self.run_in_thread
      scheduler = new
      Thread.new do
        Fiber.set_scheduler(scheduler)
        yield scheduler
      end.join
      scheduler
    end
  end
end
