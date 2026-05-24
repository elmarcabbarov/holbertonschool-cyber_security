#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

# Göndərilən URL-ə daxil edilən parametrlərlə HTTP POST sorğusu atan funksiya
def post_request(url, body_params)
  uri = URI.parse(url)
  
  # Sorğunun başlığına daxil edilən datanın JSON olduğunu bildiririk
  headers = { 'Content-Type' => 'application/json' }
  
  # Datanı JSON mətninə çeviririk
  json_data = JSON.generate(body_params)
  
  # POST sorğusunu icra edirik (Net::HTTP.post avtomatik olaraq HTTPS-i dəstəkləyir)
  response = Net::HTTP.post(uri, json_data, headers)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  
  # Gələn cavabı oxunaqlı (pretty) JSON formatında çap edirik
  parsed_body = JSON.parse(response.body)
  puts JSON.pretty_generate(parsed_body)
end
