require 'nokogiri'
require 'open-uri'
require 'uri'
require 'mysql2'

=begin
	Setting up connection to local host by using mysql2 .
=end

$client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "webSpider")

$urlx = "http://www.1mobile.com"
$url = "http://www.1mobile.com"
$urlx<< "/downloads/"
$flag = nil

=begin
By using the gem nokogiri and its method xpath the category names are searched in 
the webpage. and each category details are stored into 'x'.
=end

doc = Nokogiri::HTML(open($urlx))

x = doc.xpath('//div[@class="cont"]//div[@class="c"]//em//a')
x.each do |cat|

=begin	
Checking whether the category is "Action" in order to remove redundant data 
from being stored to database.	
=end

	if cat.text == "Action"
		$flag=1
	end	
	
	if $flag
		$j_double = cat
=begin		
	Inserting category detail into table 'app_category'.
=end

		$client.query("INSERT INTO app_category (category) VALUES ('#{cat.text.strip}')")

=begin
	Url for each category is obtained via cat['href'] and stored in $url1 and $url2
=end

		$url1 = $url + cat['href']
		$url2 = $url1

=begin		
	Using the url of each category each category pages are loaded as 
	nokogiri doc ('doc1') and using that doc1 the application name is obtained as well as
	their url
=end

		doc1 = Nokogiri::HTML(open($url2))
		y = doc1.xpath('//div[@class = "searchapps"] // ul[@id= "searchresult"]//li//p//a')
		y.each do |app_name|
			$app_name_double = app_name
			
			 
			$urly = $url + app_name['href']

=begin
	The following code refines the url from unwanted square brackets that will
	prevent nokogiri from opening the page.
=end

			if $urly.include? "["
				open = $urly.index("[")
				close = $urly.index("]",open)
				$urly[open..(close+1)]=""
			end

=begin
	Opening the application page and getting the application description
	and image urls.
=end

			$encoded_url = $urly.strip
			doc2 = Nokogiri::HTML(open($encoded_url))
			
			image_url = doc2.xpath('//div[@id = "J_detailslider"]//span//a//img')
			image_url.each do |elem|
				xele = elem['src'].gsub("'","")
				$xapp_name = $app_name_double.text.gsub("'", "")

=begin
	Inserting image urls of application to database.
=end

				$client.query("INSERT INTO app_screen (appName, screen_url) VALUES ('#{$xapp_name.strip}','#{xele.strip}')")
			end
	 
			description = doc2.xpath('//div[@id="baseinfo"]//div[@class = "simpleinfo"]').text.gsub("'"," ")

=begin
	Inserting application name, description, category to database.
=end

			$client.query("INSERT INTO app_detail (category,appName,description) VALUES ('#{$j_double.text.strip}','#{$xapp_name.strip}','#{description.strip}')")
		end			
		$url1=nil
	end
end

=begin
	Closing the database connection.
=end

$client.close
