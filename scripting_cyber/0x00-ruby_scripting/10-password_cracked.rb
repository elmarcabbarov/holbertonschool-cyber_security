#!/usr/bin/env ruby
require 'digest'

if ARGV.length != 2
  puts "Usage: 10-password_cracked.rb HASHED_PASSWORD DICTIONARY_FILE"
  exit
end

hashed_password = ARGV[0]
dictionary_file = ARGV[1]
password_found = false

File.foreach(dictionary_file) do |line|
  word = line.chomp
  hashed_word = Digest::SHA256.hexdigest(word)
  
  if hashed_word == hashed_password
    puts "Password found: #{word}"
    password_found = true
    break
  end
end

if password_found == false
  puts "Password not found in dictionary."
end
