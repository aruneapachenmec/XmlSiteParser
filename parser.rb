  
  require 'mysql2'
  require 'net/http'
  require_relative 'SiteMapParser'
  
  parse_url = "www.qburst.com"
  parse_ext = "/sitemap.xml" 
  a = SiteMapParser.new(parse_url,parse_ext)
  a.configure_database.fetch_remote_data.parse_data    
