# Quick & dirty Facebook image finder with threading
# Constant Meiring 2015

class FacebookLogos
	require 'open-uri'
	require 'open_uri_redirections'
	require 'thread'

	def initialize(*args)
		# Args should include access_token
		@args = args.compact.reduce
		@access_token = @args[:access_token]
	end

	def find_logos(brand)
		start_time = Time.now

		brand_keywords = brand.split(' ')
		brand_keywords.insert(1, 'brand')

		threads = []
		images_mutex = Mutex.new
		images = []

		brand_keywords.each do |keyword|
			keyword_encoded = ERB::Util.url_encode(keyword)
			request_url = "https://graph.facebook.com/search?q=#{keyword_encoded}&type=page&access_token=#{@access_token}"

			@results = JSON.load( open(request_url) ).first.last[0..3]
			@results.each do |r|
				threads << Thread.new(r, images) do |r, images|
					image = process_uri("http://graph.facebook.com/#{r["id"]}/picture?width=100&height=100")
					images_mutex.synchronize { images << image }
				end
			end
		end

		threads.each(&:join)

		end_time = Time.now
		total_time = (end_time - start_time)*1000
		puts "Found #{images.count} potential logos in #{total_time} milliseconds."

		images
	end

	private

	def process_uri(uri)
		open(uri, :allow_redirections => :safe) do |r|
			r.base_uri.to_s
		end
	end
end