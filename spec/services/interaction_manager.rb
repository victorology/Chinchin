require_relative '../../app/services/interaction_manager'
require 'active_support/all'

class UrbanairshipWrapper; end

describe InteractionManager do
	let(:user) { stub(:user) }
	let(:chinchin) { stub(:chinchin, first_name: "first_name", user: stub(:chinchin_user), users: []) }

	context '.view a user' do
		it 'can try to view a user and send a push message when viewed' do
			user.should_receive(:view).with(chinchin) { true }
	  	UrbanairshipWrapper.should_receive(:send).with([chinchin.user], "Someone viewed your profile!")
			InteractionManager.view(actor: user, receiver: chinchin)
		end	

		it 'can try to view a user and not send a push when not viewed' do
			user.should_receive(:view).with(chinchin) { false }
	  	UrbanairshipWrapper.should_not_receive(:send).with([chinchin.user], "Someone viewed your profile!")
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

      MessageRoomCreator.should_receive(:create).with(actor: user, receiver: chinchin)
			UrbanairshipWrapper.should_receive(:send).exactly(3).times
			InteractionManager.like(actor: user, receiver: chinchin)
		end
	end
end