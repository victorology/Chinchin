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
end
