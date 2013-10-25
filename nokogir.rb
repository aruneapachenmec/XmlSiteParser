
=begin
 The class SiteMapParser gets a url for xml page and parses all the url in 
 it to a coloumn in a table in database 
=end

class SiteMapParser

=begin 
  input : url
  output : nil
  The method initializes @url1 with the value url. 
=end

  def initialize(url)
    @url1 = url   
  end   
    
=begin
  input : @url1
  output : xml 
  This method parses the fetched data(@fetched_data) to database.
=end  

  def parse_data
    doc = Nokogiri::XML(open(@url1))
    doc.remove_namespaces!()
    @fetched_data = doc.search('url/loc').xpath('text()')
        
    #inserting the array of urls to database.
    @fetched_data.each do |xml|
    @client.query("INSERT INTO sitemaps (Qb_sitemap1) VALUES ('#{ xml }')")       
    end

    rescue Exception=>e
      puts e.message
    #closing the connection to database.    
    @client.close 
    self   
  end
    
=begin
  input : nil
  output : @client
  This method creates connection to database (ruby) using mysql2 gem.
=end

  def configure_database
    begin
      @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "ruby")
      self
      rescue Exception=>e
      puts e.message
    end
  end
end        
