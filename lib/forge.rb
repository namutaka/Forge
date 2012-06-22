# -*- encoding: utf-8 -*-
# Forge dummy datas
#

module Forge

  def self.defwords(name, words)
    const_set(name.upcase, words.to_a)
    define_method(name.downcase) do |count|
      chars(const_get("#{name}"), count)
    end
    module_function name.downcase
  end

  # U+3040-309F	Hiragana	平仮名
  defwords :HIRAGANA, "\u3041".."\u3096"
  # U+30A0-30FF	Katakana	片仮名
  defwords :KATAKANA, "\u30A1".."\u30F6"

  # SJIS
  defwords :KANJI, (0x889F..0x88FC).map {|e|[e].pack('n').encode("UTF-8", "SHIFT_JIS")}

  # U+3000-303F	CJK Symbols and Punctuation	CJKの記号及び句読点
  KUHAKU = "\u3000"
  TOUTEN = "\u3001"
  KUTEN = "\u3002"
  defwords :KIGOU, "\u3003".."\u301C"

  # U+FF00-FFEF	Halfwidth and Fullwidth Forms	半角・全角形
  defwords :FULLWIDTH, "\uFF01".."\uFF60"

  # 文字全般
  defwords :FULLCHARS, [KATAKANA, HIRAGANA,
    KANJI, KIGOU, FULLWIDTH].flatten

  def self.chars(base, count = 5)
    repeat(count) { base[rand(base.size)] }.join
  end

  def self.words(base, num = 5)
    repeat(num) { chars(base, 1 + rand(10)) }
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

end


require 'forge/record_base'

