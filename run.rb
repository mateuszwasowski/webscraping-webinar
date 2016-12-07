require 'watir-webdriver'
require 'nokogiri'
require 'csv'
require 'pry'
require './crawl.rb'

puts Time.now

crawl = Crawl.new

puts "starting..."

crawl.execute

puts "done!"
puts Time.now
