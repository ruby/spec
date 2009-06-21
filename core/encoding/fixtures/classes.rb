module EncodingSpecs
  class UndefinedConversionError
    def self.exception
      ec = Encoding::Converter.new('utf-8','ascii')
      begin
        ec.convert("\u{8765}")
      rescue Encoding::UndefinedConversionError => e
        e
      end
    end
  end
end
