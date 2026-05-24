#!/usr/bin/env ruby

# HelloWorld klassı mesajı saxlamaq və ekrana çıxarmaq üçün istifadə olunur
class HelloWorld
  # Obyekt yaradılanda avtomatik işə düşən metod
  def initialize
    @message = "Hello, World!"
  end

  # Mesajı ekrana çap edən metod
  def print_hello
    puts @message
  end
end
