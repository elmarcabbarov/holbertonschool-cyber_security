#!/usr/bin/env ruby

# Terminaldan gələn arqumentləri tab ilə formatlayıb çap edən funksiya
def print_arguments
  if ARGV.empty?
    puts "No arguments provided."
  else
    puts "Arguments:"
    ARGV.each do |arg|
      puts "\t#{arg}"
    end
  end
end
