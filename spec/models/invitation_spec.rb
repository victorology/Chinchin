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

  it 'should return invited friends exclude the friends invited before today noon' do
    now = Time.now
    TimeUtil.freeze(Time.new(now.year, now.month, now.day, 11, 0))
    Invitation.invited_friends(@user).length.should == 0
    @user.invite(@not_yet_user)
    Invitation.invited_friends(@user).length.should == 1
    TimeUtil.pass_by(30*60)
    invited_friends = Invitation.invited_friends(@user)
    invited_friends.length.should == 1
    invited_friends.first.should == @not_yet_user
    puts Invitation.first.created_at
    TimeUtil.pass_by(31*60)
    Invitation.invited_friends(@user).length.should == 0
  end

  it 'should call user.invite 5 times when invite 5 friends' do
    friends = [mock_model("User"), mock_model("User"), mock_model("User"), mock_model("User"), mock_model("User")]
    User.stub(:invite) { true }

    User.any_instance.should_receive(:invite).exactly(5).times
    Invitation.invite_friends(@user, friends, "spec_for_test")
  end

  it 'should call recharge_full_by_invitation when invite 20 more friends' do
    friends = []
    (0..19).each do |n|
      friends.push(mock_model("User"))
    end
    User.stub(:invite) { true }

    User.any_instance.should_receive(:invite).exactly(20).times
    Currency.any_instance.should_receive(:recharge_full).with("invitation")
    Invitation.invite_friends(@user, friends, "no_hearts")
  end
end
