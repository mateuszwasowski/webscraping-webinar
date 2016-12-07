require 'watir-webdriver'
require 'nokogiri'
require 'active_support/all'
require 'csv'
require 'pry'
require './fb_crawl.rb'

puts Time.now

config = YAML::load(File.open('./credentials.yml'))
crawl = FbCrawl.new config["fb_login"], config["fb_password"]

puts "starting..."

crawl.execute

puts "done!"
puts Time.now
