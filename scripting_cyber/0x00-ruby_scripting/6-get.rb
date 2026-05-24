#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

# Göndərilən URL-ə HTTP GET sorğusu atan funksiya
def get_request(url)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"

  # Gələn body-ni oxuyub səliqəli (pretty) formata salırıq
  parsed_body = JSON.parse(response.body)
  puts JSON.pretty_generate(parsed_body)
end
