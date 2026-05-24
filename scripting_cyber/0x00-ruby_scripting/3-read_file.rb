#!/usr/bin/env ruby
require 'json'

# JSON faylından userId-ləri oxuyub sayan funksiya
def count_user_ids(path)
  file_content = File.read(path)
  data = JSON.parse(file_content)
  counts = Hash.new(0)

  data.each do |item|
    counts[item['userId']] += 1
  end

  sorted_keys = counts.keys.sort
  sorted_keys.each do |key|
    puts "#{key}: #{counts[key]}"
  end
end
