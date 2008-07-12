module ARGFSpecs
  
  def self.file_args(*args)
    files = args.collect do |filename|
      # if STDIN or abslute path then return as is
      # else append the fixture path to the file
      if filename == '-' || filename[0..0] == '/' 
        filename
      else
        File.join(File.dirname(__FILE__),filename)
      end
    end
    ARGV.concat(files)
  end
  
end