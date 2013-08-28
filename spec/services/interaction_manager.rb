require 'spec_helper'
# require_relative '../../app/services/interaction_manager'
# require 'active_support/all'

# class UrbanairshipWrapper; end
# class User
# 	REGISTERED = 1
# end

# class MessageRoom
# 	WAITING_FOR_OPEN = 0
# 	OPENED_BY_USER2 = 2

# 	def self.messageRoom(user1_id, user2_id)
# 		return MessageRoom.where("user1_id = ? and user2_id = ?", user1_id, user2_id).first || MessageRoom.where("user1_id = ? and user2_id = ?", user2_id, user1_id).first
# 	end

# 	def sendMessage(writer, text)
# 	end
# end	

# class Message
# 	TEXT = 0
# end

describe InteractionManager do
	let(:user) { stub(:user, id: 100, status: 1) }
	let(:chinchin) { stub(:user, id: 200, first_name: "first_name", registered_friends: [], status: 1) }

	context '.view a user' do
		it 'can try to view a user and send a push message when viewed' do
			user.should_receive(:view).with(chinchin) { true }
	  	UrbanairshipWrapper.should_receive(:send).with([chinchin], "Someone viewed your profile!")
			InteractionManager.view(actor: user, receiver: chinchin)
		end	

		it 'can try to view a user and not send a push when not viewed' do
			user.should_receive(:view).with(chinchin) { false }
	  	UrbanairshipWrapper.should_not_receive(:send).with([chinchin], "Someone viewed your profile!")
			InteractionManager.view(actor: user, receiver: chinchin)
		end	
	end

	context '.like a user' do
		it 'can manage to like a user' do
			user.should_receive(:like).with(chinchin) { true }
			user.stub(:mutual_like).with(chinchin) { false }

			UrbanairshipWrapper.should_receive(:send).exactly(2).times
			InteractionManager.like(actor: user, receiver: chinchin)
		end

		it 'can like a user and create a message room when the like is mutual' do
			user.should_receive(:like).with(chinchin) { true }
			user.stub(:mutual_like).with(chinchin) { true }

			MessageRoom.should_receive(:create).with(user1_id: chinchin.id, user2_id: user.id, status: MessageRoom::WAITING_FOR_OPEN)
			UrbanairshipWrapper.should_receive(:send).exactly(3).times
			InteractionManager.like(actor: user, receiver: chinchin)
		end
	end

	context '.alert to friends' do
		it 'can send a message for introduce to friends' do
			ids = ['1','2']

			MessageRoom.should_receive(:create).with(user1_id: 1, user2_id: user.id, status: MessageRoom::OPENED_BY_USER2)
			MessageRoom.should_receive(:create).with(user1_id: 2, user2_id: user.id, status: MessageRoom::OPENED_BY_USER2)
			UrbanairshipWrapper.should_receive(:send).exactly(2).times
			InteractionManager.alert(actor: user, receiver: chinchin, friends_ids: ids)
		end
	end
end