#! env ruby
# -*- encoding: utf-8 -*-

require 'pp'
require 'rubygems'
require 'faker'

module EnumerateEx
  def pick
    self[rand(size)]
  end
end

class Array
  include EnumerateEx
end


module Faker

  # U+3040-309F	Hiragana	平仮名
  HIRAGANA = ("\u3041".."\u3096").to_a
  # U+30A0-30FF	Katakana	片仮名
  KATAKANA = ("\u30A1".."\u30F6").to_a

  # U+4E00-9FFF	CJK Unified Ideographs	CJK統合漢字
  KANJI = ("\u4E00".."\u9FA1").to_a

  # U+3000-303F	CJK Symbols and Punctuation	CJKの記号及び句読点
  KUHAKU = "\u3000"
  TOUTEN = "\u3001"
  KUTEN = "\u3002"
  KIGOU = ("\u3003".."\u301C" ).to_a

  # U+FF00-FFEF	Halfwidth and Fullwidth Forms	半角・全角形
  FULLWIDTH = ("\uFF01".."\uFF60").to_a

  # 文字全般
  FULLCHARS = [KATAKANA, HIRAGANA,
    KANJI, KIGOU, FULLWIDTH].flatten

  def self.fullchars(base, count = 5)
    repeat(count) { base.pick }.join
  end

  def self.words(base, num = 5)
    repeat(num) { fullchars(base, 1 + rand(10)) }
  end

  def self.digits(digit)
    "%0#{digit}d" % number(digit)
  end

  def self.number(digit)
    rand(10 ** digit)
  end

  def self.repeat(count)
    (1..count).inject([]) do |ret|
      ret << yield
    end
  end

  def self.main
    pp fullchars(FULLWIDTH)
    pp words(FULLCHARS, 5)
    pp digits(10)
  end

end



=begin
puts Faker::Lorem.characters(10)
puts Faker::Lorem.paragraph(2, false)
puts Faker::Lorem.words(2, false).join("^")
puts :aaa
puts [ 0x3000 ].pack('U')
=end

#pp (10..20).inject([]) {|ret| ret << 1}.join
#pp [111,22].pick

Faker.main

