#!/usr/bin/env ruby

# Terminaldan gələn arqumentləri dəqiq formatda çap edən funksiya
def print_arguments
  if ARGV.empty?
    puts "No arguments provided."
  else
    puts "Arguments:"
    ARGV.each do |arg|
      puts "    #{arg}"
    end
  end
end
