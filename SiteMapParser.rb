class SiteMapParser
    def initialize(url,ext)
        @@fetched_data = ""
        @parsed_xml = []
        @url1 = url
        @ext1 = ext 
    end   
    #method to get remote data to str.
    def fetch_remote_data
        Net::HTTP.start(@url1, 80 ) do |http|
        @@fetched_data = ( http.get(@ext1).body )
        end
        self
    end
    #method for parsing the fetched data to database.
    def parse_data
        i=0
        while @@fetched_data.include? "<loc>"
            open = @@fetched_data.index("<loc>")
            close = @@fetched_data.index("</loc>",open)
            value = @@fetched_data[open+5..close-1]
            @parsed_xml[i] = value
            i += 1
            @@fetched_data[open..close] = '' if close
        end
         #inserting the array of urls to database.
        for j in (0...i)
            @client.query("INSERT INTO sitemaps (Qb_sitemap) VALUES ('#{@parsed_xml[j]}')")
	    end       
        print @parsed_xml
        rescue Exception=>e
            puts e.message

    end
    #method for creating connection to database.
    def configure_database
        begin
            @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "ruby")
            self
            rescue Exception=>e
                puts e.message
        end
    end
end        
