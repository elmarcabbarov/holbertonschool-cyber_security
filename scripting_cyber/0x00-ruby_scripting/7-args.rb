#!/usr/bin/env ruby

# Terminaldan gələn arqumentləri çap edən funksiya
def print_arguments
  if ARGV.empty?
    puts "No arguments provided."
  else
    ARGV.each_with_index do |arg, index|
      puts "#{index + 1}. #{arg}"
    end
  end
end
