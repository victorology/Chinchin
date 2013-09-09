class NotificationPush < NotificationMedia
	def notify()
		@options.each do |option|
			UrbanairshipWrapper.send([option[:user]], option[:message])
		end
	end
end