dir = "../fixtures/code"
use_realpath = File.respond_to?(:realpath)
CODE_LOADING_DIR = use_realpath ? File.realpath(dir, __FILE__) : File.expand_path(dir, __FILE__)

# Running directly with ruby some_spec.rb
unless ENV['MSPEC_RUNNER']
  begin
    require 'mspec'
    require 'mspec/commands/mspec-run'
  rescue LoadError
    puts "Please add -Ipath/to/mspec/lib or install the MSpec gem to run the specs."
    exit 1
  end

  ARGV.unshift $0
  MSpecRun.main
end
