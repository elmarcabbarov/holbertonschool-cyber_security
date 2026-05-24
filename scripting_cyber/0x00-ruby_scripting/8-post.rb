#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params)
  uri = URI.parse(url)
  headers = { 'Content-Type' => 'application/json' }
  json_data = JSON.generate(body_params)
  
  response = Net::HTTP.post(uri, json_data, headers)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  
  parsed_body = JSON.parse(response.body)
  
  if parsed_body.empty?
    puts "{}"
  else
    puts JSON.pretty_generate(parsed_body)
  end
end
