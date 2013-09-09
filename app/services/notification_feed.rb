class NotificationFeed < NotificationMedia
	def notify()
		@options.each do |option|
			feed = Feed.new
			feed.feed_type = option[:type]
			feed.message = option[:message]
			feed.user = option[:user]
			feed.target_user = option[:target_user]
			feed.save
		end
	end
end