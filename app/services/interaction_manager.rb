class InteractionManager
	attr_reader :actor, :receiver, :friends

	def self.view(options)
		new(options).view		
	end

	def self.like(options)
		new(options).like		
	end

	def self.alert(options)
		new(options).alert
	end

	def initialize(options)
		@actor = options[:actor]
		@receiver = options[:receiver]
		@friends = options[:friends]
	end

	def alert()
		@friends.each do |friend|
			messageRoom = MessageRoom.messageRoom(friend.id, actor.id)
			if messageRoom.nil?
				messageRoom = MessageRoom.create!(user1_id: friend.id, user2_id: actor.id, status: MessageRoom::OPENED_BY_USER2)
			end
			messageRoom.sendMessage(actor, "What do you think about #{receiver.name}?")			
		end
		Notification.notify(type: "alert", media: ['feed'], people: [actor, receiver], receivers: @friends)
	end

	def view()
		saved = actor.view(receiver)
		if saved
 	  	# UrbanairshipWrapper.send([receiver], "Someone viewed your profile!")
 	  	Notification.notify(type: "view", media: [], receivers: [receiver])
    end
	end

	def like()
		saved = actor.like(receiver)

		if saved
	    # UrbanairshipWrapper.send(receiver.registered_friends, "Someone likes #{receiver.first_name}!")
	    Notification.notify(type: "like_friend", media: ['push', 'feed'], people: [receiver], receivers: receiver.registered_friends)
		end

    if receiver.status == User::REGISTERED
      # UrbanairshipWrapper.send([receiver], "Someone likes you!")
      Notification.notify(type: "like", media: ['push', 'feed'], receivers: [receiver])
      if actor.mutual_like(receiver)
      	MessageRoom.create(user1_id: receiver.id,
      										 user2_id: actor.id,
								       		 status: MessageRoom::WAITING_FOR_OPEN)
        # UrbanairshipWrapper.send([receiver, self], "You are connected with someone you liked! Check out your messages")
        Notification.notify(type: "match", media: ['push', 'feed'], people: [actor, receiver], receivers:[actor, receiver])
        Notification.notify(type: "match_friend", media: ['push', 'feed'], receivers: actor.registered_friends+receiver.registered_friends)
      end
    end
	end
end