#!/usr/bin/env ruby
require 'optparse'

FILE_NAME = 'tasks.txt'
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:remove] = index.to_i
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

if options[:add]
  File.open(FILE_NAME, "a") do |file|
    file.puts(options[:add])
  end
  puts "Task '#{options[:add]}' added."
end

if options[:list]
  if File.exist?(FILE_NAME)
    File.readlines(FILE_NAME).each_with_index do |line, index|
      puts "#{index + 1}. #{line.chomp}"
    end
  end
end

if options[:remove]
  if File.exist?(FILE_NAME)
    tasks = File.readlines(FILE_NAME)
    index = options[:remove] - 1
    
    if index >= 0 && index < tasks.length
      removed_task = tasks.delete_at(index).chomp
      File.write(FILE_NAME, tasks.join)
      puts "Task '#{removed_task}' removed."
    end
  end
end
