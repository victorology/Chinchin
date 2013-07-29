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
		if saved and receiver.user.present?
 	  	UrbanairshipWrapper.send([receiver.user], "Someone viewed your profile!")
    end
	end

	def like()
		saved = actor.like(receiver)

		if saved
	    UrbanairshipWrapper.send(receiver.users, "Someone likes #{receiver.first_name}!")
		end

    if not receiver.user.nil?
      UrbanairshipWrapper.send([receiver.user], "Someone likes you!")
      if actor.mutual_like(receiver)
      	MessageRoomCreator.create(actor: actor, receiver: receiver)
        # message_room = MessageRoom.new
      #   messageRoom.user1 = chinchin.user
      #   messageRoom.user2 = self
      #   messageRoom.status = MessageRoom::WAITING_FOR_OPEN
      #   if messageRoom.save
          UrbanairshipWrapper.send([receiver.user, self], "You are connected with someone you liked! Check out your messages")
      #   end

      end
      # me = Chinchin.find_by_uid(self.uid)
      # if receiver.user.liked(me)
      #   messageRoom = MessageRoom.new
      #   messageRoom.user1 = chinchin.user
      #   messageRoom.user2 = self
      #   messageRoom.status = MessageRoom::WAITING_FOR_OPEN
      #   if messageRoom.save
      #     UrbanairshipWrapper.send([receiver.user, self], "You are connected with someone you liked! Check out your messages")
      #   end
      # end
    end
	end
end