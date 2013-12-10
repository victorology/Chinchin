require 'spec_helper'

describe Invitation do
  before(:each) do
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
    @not_yet_user = FactoryGirl.create(:user, name: 'lee', gender: 'male', uid: '0001', status: 0)
  end

  it 'should return invited friends when Invitation.invited_friends called' do
    Invitation.invited_friends(@user).length.should == 0
    @user.invite(@not_yet_user)
    invited_friends = Invitation.invited_friends(@user)
    invited_friends.length.should == 1
    invited_friends.first.should == @not_yet_user
  end

  it 'should return invited friends exclude invited 24 hours ago' do
    now = Time.now
    TimeUtil.freeze(now)
    Invitation.invited_friends(@user).length.should == 0
    @user.invite(@not_yet_user)
    TimeUtil.pass_by(1*60*60)
    invited_friends = Invitation.invited_friends(@user)
    invited_friends.length.should == 1
    invited_friends.first.should == @not_yet_user
    TimeUtil.pass_by(23*60*61)
    Invitation.invited_friends(@user).length.should == 0
  end
end
