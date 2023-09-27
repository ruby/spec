require 'zlib'

begin
  child_env = {}
  child_env['DFLTCC'] = '0' if RUBY_PLATFORM =~ /s390x/
  Zlib::CHILD_ENV = child_env.freeze
end
