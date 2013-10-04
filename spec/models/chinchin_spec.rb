require 'spec_helper'

describe Chinchin do
  it 'returns empty array when chinchin has no mutual friends with current_user' do
    user = FactoryGirl.create(:user, name: 'kim', gender: 'male')
    user2 = FactoryGirl.create(:user, name: 'lee', gender: 'male')
    chinchin = FactoryGirl.create(:user, name: 'lee', gender:'male')
    FactoryGirl.create(:friendship, user: user2, chinchin: user)

    chinchin.mutual_friendships(user).count.should == 0
  end

  it 'returns user array when chinchin has mutual friends with current_user' do
    user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
    user2 = FactoryGirl.create(:user, name: 'lee', gender: 'male', uid: '1234', status: 1)
    chinchin = FactoryGirl.create(:user, name: 'lee', gender:'male', uid: '3456', status: 1)
    chinchin2 = FactoryGirl.create(:user, name: 'park', gender:'female', uid: '1111', status: 0)
    FactoryGirl.create(:friendship, user: user, chinchin: chinchin)
    FactoryGirl.create(:friendship, user: user, chinchin: chinchin2)
    FactoryGirl.create(:friendship, user: user2, chinchin: chinchin2)

    user.chinchins.should eq [chinchin, chinchin2]
    user2.chinchins.should eq [chinchin2]
    user.registered_friends.should eq [chinchin]
    chinchin2.mutual_friendships(user).should eq []

    FactoryGirl.create(:friendship, user: user2, chinchin: chinchin)
    user.mutual_friendships(user2).should == [chinchin]
  end
end
