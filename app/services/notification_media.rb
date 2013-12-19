class NotificationMedia
	def initialize(options)
		options.each { |k,v| instance_variable_set("@#{k}", v) }

		@message = NotificationString.message(options)
		@options = []
		if @type == "match"
			prepare_for_match()
		else
			prepare()
		end
	end

	def prepare_for_match()
    user = @receivers[0]
    target_user = @receivers[1]
		@options.push({type: "match", message: @message[0], user: user, target_user: target_user, matched: {name: target_user.name, uid: target_user.uid}})
		@options.push({type: "match", message: @message[1], user: target_user, target_user: user, matched: {name: user.name, uid: user.uid}})
	end

	def prepare()
		case @type
		when "like_friend"
			@target_user = @people[0]
		when "alert"
			@target_user = @people[0]
		else #like, match_friend
			@target_user = nil
		end

		@receivers.each do |receiver|
			option = {type: @type, message: @message, user: receiver, target_user: @target_user}
			@options.push(option)
		end
	end
end