#getting the gems required for operation of code
require 'nokogiri'
require 'open-uri'
require 'mysql2'
require_relative 'nokogir'

#creating 'parse' an object of class 'SiteMapParser'. 
parse = SiteMapParser.new("http://www.qburst.com/sitemap.xml")

#calling methods to parse the xml page.
parse.configure_database.parse_data