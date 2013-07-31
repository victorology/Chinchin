class InteractionManager
	attr_reader :actor, :receiver

	def self.view(options)
		new(options).view		
	end

	def self.like(options)
		new(options).like		
	end

	def initialize(options)
		@actor = options[:actor]
		@receiver = options[:receiver]
	end

	def view()
		saved = actor.view(receiver)
		if saved
 	  	UrbanairshipWrapper.send([receiver], "Someone viewed your profile!")
    end
	end

	def like()
		saved = actor.like(receiver)

		if saved
	    UrbanairshipWrapper.send(receiver.registered_friends, "Someone likes #{receiver.first_name}!")
		end

    if receiver.status == User::REGISTERED
      UrbanairshipWrapper.send([receiver], "Someone likes you!")
      if actor.mutual_like(receiver)
      	MessageRoom.create(user1_id: receiver.id,
      										 user2_id: actor.id,
								       		 status: MessageRoom::WAITING_FOR_OPEN)
        UrbanairshipWrapper.send([receiver, self], "You are connected with someone you liked! Check out your messages")
      end
    end
	end
end