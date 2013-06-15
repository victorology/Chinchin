require 'spec_helper'

describe MessageRoom do
  it 'returns one message room when two user like each other' do
    MessageRoom.all.count.should == 0
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.like(chinchin2)
    user1.liked(chinchin2).should == true
    MessageRoom.all.count.should == 0
    user2.like(chinchin1)
    user2.liked(chinchin1).should == true
    MessageRoom.all.count.should == 1
    MessageRoom.last.status = MessageRoom::WAITING_FOR_OPEN
  end

  it 'returns MessageRoom list with current user if it is activated' do
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.message_rooms.count.should == 0

    user1.like(chinchin2)
    user1.message_rooms.count.should == 0
    user2.like(chinchin1)

    user1.message_rooms.count.should == 1
    user2.message_rooms.count.should == 1
  end

  it 'returns no MessageRoom list with current user if it is not activated' do
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.like(chinchin2)
    user2.like(chinchin1)
    messageRoom = user1.message_rooms.first
    messageRoom.close(user1)
    messageRoom.status.should == MessageRoom::CLOSED_BY_USER1
    user1.message_rooms.count.should == 0
    user2.message_rooms.count.should == 0
  end

  it 'returns its status OPENED_BY_USER1 when user1 open the message room' do
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.like(chinchin2)
    user2.like(chinchin1)

    messageRoom = user1.message_rooms.first
    messageRoom.status.should == MessageRoom::WAITING_FOR_OPEN

    messageRoom.open(user1)
    messageRoom.status.should == MessageRoom::OPENED_BY_USER1
  end

  it 'returns its status CLOSED_BY_USER2 when user2 close the message room' do
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.like(chinchin2)
    user2.like(chinchin1)

    messageRoom = user1.message_rooms.first
    messageRoom.status.should == MessageRoom::WAITING_FOR_OPEN

    messageRoom.close(user2)
    messageRoom.status.should == MessageRoom::CLOSED_BY_USER2
  end
end
