#!/usr/bin/env ruby
require 'digest'

# Arqumentlərin düzgün verildiyini yoxlayırıq
if ARGV.length != 2
  puts "Usage: 10-password_cracked.rb HASHED_PASSWORD DICTIONARY_FILE"
  exit
end

target_hash = ARGV[0]
dictionary_file = ARGV[1]
password_found = false

# Lüğət faylını sətir-sətir oxuyuruq
File.foreach(dictionary_file) do |line|
  # Sətir sonundakı boşluqları və yeni sətir simvollarını (\n) təmizləyirik
  word = line.chomp
  
  # Sözü SHA-256 ilə hash edirik
  hashed_word = Digest::SHA256.hexdigest(word)
  
  # Hədəf hash ilə yoxlayırıq
  if hashed_word == target_hash
    puts "Password found: #{word}"
    password_found = true
    break
  end
end

# Əgər dövr bitdikdən sonra parol tapılmayıbsa, müvafiq mesajı veririk
if password_found == false
  puts "Password not found in dictionary."
end
