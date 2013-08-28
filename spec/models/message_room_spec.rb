require 'spec_helper'

describe MessageRoom do
  let(:user1) { FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123', status: User::REGISTERED) }
  let(:user2) { FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345', status: User::REGISTERED) }
  let(:friend) { FactoryGirl.create(:user, gender:'male', name:'Park', uid:'567', status: User::REGISTERED) }

  it 'returns one message room when two user like each other' do
    MessageRoom.all.count.should == 0
    InteractionManager.like(actor: user1, receiver: user2)
    user1.liked(user2).should == true
    InteractionManager.like(actor: user2, receiver: user1)
    user2.liked(user1).should == true

    user1.mutual_like(user2).should == true
    user2.mutual_like(user1).should == true
    MessageRoom.count.should == 1
    MessageRoom.last.status = MessageRoom::WAITING_FOR_OPEN
  end

  it 'returns MessageRoom list with current user if it is activated' do
    user1.message_rooms.count.should == 0
    InteractionManager.like(actor: user1, receiver: user2)
    user1.message_rooms.count.should == 0
    InteractionManager.like(actor: user2, receiver: user1)

    user1.message_rooms.count.should == 1
    user2.message_rooms.count.should == 1
  end

  it 'returns no MessageRoom list with current user if it is not activated' do
    InteractionManager.like(actor: user1, receiver: user2)
    InteractionManager.like(actor: user2, receiver: user1)
    messageRoom = user1.message_rooms.first
    messageRoom.close(user1)
    messageRoom.status.should == MessageRoom::CLOSED_BY_USER1
    user1.message_rooms.count.should == 0
    user2.message_rooms.count.should == 0
  end

  it 'returns its status OPENED_BY_USER1 when user1 open the message room' do
    InteractionManager.like(actor: user1, receiver: user2)
    InteractionManager.like(actor: user2, receiver: user1)
    messageRoom = user1.message_rooms.first
    messageRoom.status.should == MessageRoom::WAITING_FOR_OPEN

    messageRoom.open(user1)
    messageRoom.status.should == MessageRoom::OPENED_BY_USER1
  end

  it 'returns its status CLOSED_BY_USER2 when user2 close the message room' do
    InteractionManager.like(actor: user1, receiver: user2)
    InteractionManager.like(actor: user2, receiver: user1)
    messageRoom = user1.message_rooms.first
    messageRoom.status.should == MessageRoom::WAITING_FOR_OPEN

    messageRoom.close(user2)
    messageRoom.status.should == MessageRoom::CLOSED_BY_USER2
  end

  context '.alert to friends' do
    it 'can make a message room with friends who the user want to share his likeness and send a initial message' do
      friends_ids = ['300', '301']
      user1.message_rooms.count.should == 0
      InteractionManager.alert(actor: user1, receiver: user2, friends_ids: friends_ids)
      user1.message_rooms.count.should == 2
      messageRoom = user1.message_rooms.first
      messageRoom.status.should == MessageRoom::OPENED_BY_USER2
      messageRoom.messages.first.content.should == "I like #{user2.first_name}"
    end

    it 'only make one message room with two friends_ids when the other is already created' do
      friends_ids = ['300', friend.id]
      user1.message_rooms.count.should == 0
      MessageRoom.create(:user1_id => friend.id, :user2_id => user1.id, :status => MessageRoom::OPENED_BY_USER2)
      user1.message_rooms.count.should == 1
      InteractionManager.alert(actor: user1, receiver: user2, friends_ids: friends_ids)
      user1.message_rooms.count.should == 2
      messageRoom = user1.message_rooms.last
      messageRoom.status.should == MessageRoom::OPENED_BY_USER2
      messageRoom.messages.last.content.should == "I like #{user2.first_name}"
    end
  end
end