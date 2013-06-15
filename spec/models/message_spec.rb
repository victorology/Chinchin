require 'spec_helper'

describe Message do
  it 'occurs error when it was sent to the message room which is not opened yet' do
    user1 = FactoryGirl.create(:user, gender:'male', name:'Kim', uid:'123')
    chinchin1 = FactoryGirl.create(:chinchin, user:user1, name:'Kim', uid:'123')
    user2 = FactoryGirl.create(:user, gender:'female', name:'Lee', uid:'345')
    chinchin2 = FactoryGirl.create(:chinchin, user:user2, name:'Lee', uid:'345')

    user1.like(chinchin2)
    user1.liked(chinchin2).should == true
    user2.like(chinchin1)
    user2.liked(chinchin1).should == true

    messageRoom = MessageRoom.last
    messageRoom.messages.count.should == 0
    expect { messageRoom.sendMessage(user1, 'Hello') }.to raise_error
    messageRoom.messages.count.should == 0
    messageRoom.status = MessageRoom::OPENED_BY_USER1
    messageRoom.sendMessage(user1, 'Hello').should == true
    messageRoom.messages.count.should == 1
  end
end
