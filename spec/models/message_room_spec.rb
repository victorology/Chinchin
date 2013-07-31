require 'spec_helper'

describe MessageRoom do
  let(:user1) { FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123', status: User::REGISTERED) }
  let(:user2) { FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345', status: User::REGISTERED) }

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
end