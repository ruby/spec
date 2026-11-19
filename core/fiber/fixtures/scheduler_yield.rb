require_relative 'hook_scheduler'

class FiberSpecs::HookScheduler
  def yield
    @events << [:yield]
    @ready << Fiber.current
    Fiber.yield
  end
end

trapped = false
Signal.trap(:USR1) { trapped = true }

scheduler = FiberSpecs::HookScheduler.new
Thread.new do
  sleep 0.1
  Process.kill(:USR1, Process.pid)
end

Fiber.set_scheduler(scheduler)
Fiber.schedule do
  # A blocking operation without GVL, interrupted by a signal handled by a Ruby-level trap
  Process.wait(spawn(RbConfig.ruby, "-e", "sleep 0.5"))
end
Fiber.scheduler.run

print "trapped=#{trapped} yielded=#{!scheduler.events_named(:yield).empty?}"
