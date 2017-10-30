require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../../kernel/shared/sprintf', __FILE__)

describe "File#printf" do
  it_behaves_like :kernel_sprintf, -> (format, *args) {
    begin
      @filename = tmp("printf.txt")

      File.open(@filename, "w") do |f|
        f.printf(format, *args)
      end
      string = File.read(@filename)

      string
    ensure
      rm_r @filename
    end
  }
end
