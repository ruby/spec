require_relative '../../spec_helper'

class BeLocaleEnvEncodingString
  def initialize(name = 'locale')
    encoding = Encoding.find(name)
    @encodings = (encoding = Encoding::US_ASCII) ?
                   [encoding, Encoding::ASCII_8BIT] : [encoding]
  end

  def matches?(actual)
    @actual = actual = actual.encoding
    @encodings.include?(actual)
  end

  def failure_message
    ["Expected #{@actual} to be #{@encodings.join(' or ')}"]
  end

  def negative_failure_message
    ["Expected #{@actual} not to be #{@encodings.join(' or ')}"]
  end
end

class String
  def be_locale_env(expected = 'locale')
    BeLocaleEnvEncodingString.new(expected)
  end
end
