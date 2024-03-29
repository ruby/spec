# encoding: utf-8
module ArraySpecs
  def self.array_with_usascii_and_7bit_utf8_strings
    [
      'foo'.dup.force_encoding('US-ASCII'),
      'bar'
    ]
  end

  def self.array_with_usascii_and_utf8_strings
    [
      'foo'.dup.force_encoding('US-ASCII'),
      'báz'
    ]
  end

  def self.array_with_7bit_utf8_and_usascii_strings
    [
      'bar',
      'foo'.dup.force_encoding('US-ASCII')
    ]
  end

  def self.array_with_utf8_and_usascii_strings
    [
      'báz',
      'bar',
      'foo'.dup.force_encoding('US-ASCII')
    ]
  end

  def self.array_with_usascii_and_utf8_strings
    [
      'foo'.dup.force_encoding('US-ASCII'),
      'bar',
      'báz'
    ]
  end

  def self.array_with_utf8_and_7bit_binary_strings
    [
      'bar',
      'báz',
      'foo'.dup.force_encoding('BINARY')
    ]
  end

  def self.array_with_utf8_and_binary_strings
    [
      'bar',
      'báz',
      [255].pack('C').force_encoding('BINARY')
    ]
  end

  def self.array_with_usascii_and_7bit_binary_strings
    [
      'bar'.dup.force_encoding('US-ASCII'),
      'foo'.dup.force_encoding('BINARY')
    ]
  end

  def self.array_with_usascii_and_binary_strings
    [
      'bar'.dup.force_encoding('US-ASCII'),
      [255].pack('C').force_encoding('BINARY')
    ]
  end
end
