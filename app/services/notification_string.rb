class NotificationString
	def self.message(options)
		new(options).message
	end

	def initialize(options)
		options.each { |k,v| instance_variable_set("@#{k}", v) }
	end

	def message()
		message = ""
		begin
			case @type
				when "like"
					"Someone likes you!"
				when "like_friend"
					"Someone likes #{@people[0].first_name}!"
				when "match"
					["Congrats! You've been matched with #{@people[1].first_name}! Message now.",
					 "Congrats! You've been matched with #{@people[0].first_name}! Message now."]
				when "match_friend"
					"Two of your friends are a match!"
				when "alert"
					"#{@people[0].first_name} likes #{@people[1].first_name}!"
        when "heart_full"
          "You have a full set of hearts. See more Chinchins!"
				else
					nil
			end		
		rescue
			nil
		end
	end
end