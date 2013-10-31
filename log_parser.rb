=begin
	The class LogParser will parse a log file and provides number of requests made grouped
	by date and time and also finds the url which took the maximum time for request.
	Methods : file_check (generates the grouped request , the maximum time taken by url)
						number_request (outputs the grouped request)
						max_time_url (outputs the url which takes the maximum time)
=end

class LogParser

=begin	
	Initializes a string @file and a hash variable and fixnum variable @max (to save max time taken)
	input : path (provides the path of the log file)
	output : nil		
=end

	def initialize(path)	
		@file = File.read(path)
		@hash = Hash.new(0)
		@max = 0
	end	

=begin
	Generates the grouped request and the maximum time taken by url.
	input : @file
	output : @hash, @max
=end

	def file_check
		@file.each_line do |line|
			#finding the number of request based on time.
			match_true = /\d{1,2}\/[A-Z][a-z][a-z]\/\d{4}\:\d{1,2}/.match(line)
			if match_true
				@hash[match_true[0]] += 1
			end
			#finding the max request time. 
			 time = /\d+$/.match(line)
			 if time
			 	temp = time[0].to_i	
				if (temp) > @max
			 		@max = temp
			 	end
			 end	 
		end
		self
	end

=begin
	Prints the grouped request by time and date .
	input : @hash
	output : nil
=end

	def number_request
		@hash.each do |val1,val2|
			puts "#{val1}:#{val2}"
		end
	end

=begin
	Prints the url which took the maximum request time.
	input : @max, @file
	output : nil
=end

	def max_time_url
		@file.each_line do |line|
			# finding the url of the line with maximum request time.
			if line.include? @max.to_s
				url =  /"https?:\/\/[\S]+/.match(line)
				if url 
					puts "max time is taken by #{url[0]} ie #{@max} secs"
				end
			end
		end
		self
	end
end

logObject = LogParser.new("logfile.log")
logObject.file_check.max_time_url.number_request
 
