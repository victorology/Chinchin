require 'spec_helper'

describe Chinchin do
  it 'returns empty array when chinchin has no mutual friends with current_user' do
    user = FactoryGirl.create(:user, name: 'kim', gender: 'male')
    user2 = FactoryGirl.create(:user, name: 'lee', gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, name: 'lee', gender:'male')
    FactoryGirl.create(:friendship, user: user2, chinchin: chinchin)

    chinchin.mutual_friends(user).count.should == 0
  end

  it 'returns user array when chinchin has mutual friends with current_user' do
    user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000')
    user2 = FactoryGirl.create(:user, name: 'lee', gender: 'male', uid: '1234')
    chinchin = FactoryGirl.create(:chinchin, name: 'lee', gender:'male', user:user2, uid: '1234')
    chinchin2 = FactoryGirl.create(:chinchin, name: 'park', gender:'female', uid: '1111')
    FactoryGirl.create(:friendship, user: user, chinchin: chinchin)
    FactoryGirl.create(:friendship, user: user2, chinchin: chinchin2)

    chinchin.user.should == user2
    user.chinchins.should == [chinchin]
    user2.chinchins.should == [chinchin2]
    user.friends_in_chinchin.should == [chinchin]
    chinchin2.users.should == [user2]
    chinchin2.mutual_friends(user).should == [user2]
  end
end
