require 'spec_helper'

describe UrbanairshipWrapper do
  it 'never send notification when users has no device_tokens and apids' do
    Urbanairship.should_not_receive(:push)
    user1 = FactoryGirl.create(:user, device_token: nil, apid: nil)
    user2 = FactoryGirl.create(:user, device_token: nil, apid: nil)
    UrbanairshipWrapper.send([user1, user2], 'haha')
  end

  it 'send only ios push with one user' do
    Urbanairship.should_receive(:push).with({:device_tokens => ['1234'], :aps => {:alert=>'haha', :badge=>1}, :type=>"info"}).exactly(1).times()
    user1 = FactoryGirl.create(:user, device_token: '1234', apid: nil)
    user2 = FactoryGirl.create(:user, device_token: nil, apid: nil)
    UrbanairshipWrapper.send([user1, user2], 'haha')
  end

  it 'send two ios push and one android push' do
    Urbanairship.should_receive(:push).with({:device_tokens => ['1234', '4567'], :aps => {:alert=>'haha', :badge=>1}, :type=>'info'}).exactly(1).times()
    Urbanairship.should_receive(:push).with({:apids => ['890'], :android => {:alert=>'haha'}}).exactly(1).times()
    user1 = FactoryGirl.create(:user, device_token: '1234', apid: nil)
    user2 = FactoryGirl.create(:user, device_token: '4567', apid: '890')
    UrbanairshipWrapper.send([user1, user2], 'haha')
  end
end