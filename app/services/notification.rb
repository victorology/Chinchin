class Notification
	attr_reader :type, :media

	def self.notify(options)
		new(options).notify
	end

	def initialize(options)
		options.each { |k,v| instance_variable_set("@#{k}", v) }
		new_options = options.clone
		new_options.delete(:media)

		@available_media = {
			'email'	=> NotificationEmail.new(new_options),
			'push'	=> NotificationPush.new(new_options),
			'feed'	=> NotificationFeed.new(new_options)
		}
	end

	def notify()
		if @media and @media.is_a?(Array)
			for medium in @media
				medium_object = @available_media[medium]
				medium_object.notify()
			end
		end
	end
end