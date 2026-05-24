#!/usr/bin/env ruby

# CaesarCipher klassı mesajları şifrələmək və deşifrələmək üçündür
class CaesarCipher
  # Konstruktor shift (sürüşmə) dəyərini təyin edir
  def initialize(shift)
    @shift = shift
  end

  # Mesajı şifrələyən metod
  def encrypt(message)
    cipher(message, @shift)
  end

  # Şifrələnmiş mesajı açan metod
  def decrypt(message)
    cipher(message, -@shift)
  end

  private

  # Şifrələmə və deşifrələmə işini icra edən daxili metod
  def cipher(message, shift)
    result = ""
    
    message.each_char do |char|
      case char
      when "A".."Z"
        base = "A".ord
        result += (((char.ord - base + shift) % 26) + base).chr
      when "a".."z"
        base = "a".ord
        result += (((char.ord - base + shift) % 26) + base).chr
      else
        result += char
      end
    end
    
    result
  end
end
