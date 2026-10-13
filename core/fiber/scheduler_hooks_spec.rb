require_relative '../../spec_helper'
require_relative 'fixtures/hook_scheduler'

describe "Fiber::Scheduler hooks" do
  ruby_version_is "4.0" do
    describe "#fiber_interrupt" do
      it "is called with the blocked fiber and an IOError when its IO is closed by another fiber" do
        blocked_fiber = nil
        error = nil

        scheduler = FiberSpecs::HookScheduler.run_in_thread do
          r, w = IO.pipe
          Fiber.schedule do
            blocked_fiber = Fiber.current
            begin
              r.read(1)
            rescue IOError => e
              error = e
            end
          end
          Fiber.schedule { r.close }
          Fiber.scheduler.run
          w.close
        end

        events = scheduler.events_named(:fiber_interrupt)
        events.should_not.empty?
        _, fiber, exception = events.first
        fiber.should.equal?(blocked_fiber)
        exception.should.is_a?(IOError)
        error.should.is_a?(IOError)
      end
    end

    platform_is_not :windows do
      describe "#yield" do
        it "is called when a blocking operation is interrupted by a signal" do
          ruby_exe(fixture(__FILE__, "scheduler_yield.rb")).should == "trapped=true yielded=true"
        end
      end
    end

    describe "#io_close" do
      it "is called when closing an IO from a non-blocking fiber" do
        fileno = nil

        scheduler = FiberSpecs::HookScheduler.run_in_thread do
          r, w = IO.pipe
          Fiber.schedule do
            fileno = w.fileno
            w.close
            r.close
          end
        end

        scheduler.events_named(:io_close).map(&:last).should.include?(fileno)
      end
    end

    describe "#io_write" do
      it "is called with the buffered data when flushing the IO write buffer" do
        scheduler = FiberSpecs::HookScheduler.run_in_thread do
          Fiber.schedule do
            File.open(File::NULL, "w") do |file|
              file.sync = false
              file.write("hello")
              file.flush
            end
          end
        end

        scheduler.events_named(:io_write).map(&:last).should.include?("hello")
      end
    end
  end
end
