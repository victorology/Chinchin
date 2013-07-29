require_relative '../../app/services/interaction_manager'

describe InteractionManager do
	let(:user) { stub(:user) }
	let(:chinchin) { stub(:chinchin) }

	it 'can manage to view a user' do
		user.should_receive(:view).with(chinchin)
		InteractionManager.new(actor: user, receiver: chinchin).view
	end	

	it 'can manage to like a user' do
		user.should_receive(:like).with(chinchin)
		InteractionManager.new(actor: user, receiver: chinchin).like
	end
end