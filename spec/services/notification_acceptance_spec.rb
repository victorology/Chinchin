require 'spec_helper'

describe Notification do
	user = FactoryGirl.create(:user, :first_name => 'Charlie')
	target_user = FactoryGirl.create(:user, :first_name => 'Eunmi')
	friend1 = FactoryGirl.create(:user)
	friend2 = FactoryGirl.create(:user)
  Feed.delete_all

	context 'feed' do
		it 'like' do
			Notification.notify(type: "like", media: ['feed'], receivers: [target_user])
			Feed.all.count.should eq 1
			Feed.first.message.should == "Someone likes you!"
		end

		it 'match' do
			Notification.notify(type: "match", media: ['feed'], people: [user, target_user], receivers: [user, target_user])
			Feed.all.count.should == 2
			Feed.first.message.should == "Congrats! You've been matched with Eunmi! Message now."
			Feed.first.user.should == user
			Feed.first.target_user.should == target_user
			Feed.last.message.should == "Congrats! You've been matched with Charlie! Message now."
			Feed.last.user.should == target_user
			Feed.last.target_user.should == user
		end

		it 'alert' do
			Notification.notify(type: "alert", media: ['feed'], people: [user, target_user], receivers: [friend1, friend2])
			Feed.all.count.should == 2
			Feed.first.message.should eq "Charlie likes Eunmi!"
			Feed.first.user.should == friend1
			Feed.first.target_user.should == user
		end
	end

	context 'push' do
		it 'like' do
			UrbanairshipWrapper.should_receive(:send).with([target_user], "Someone likes you!", "like")
			Notification.notify(type: "like", media: ['push'], receivers: [target_user])
		end

		it 'like_friend' do
			UrbanairshipWrapper.should_receive(:send).with([user], "Someone likes #{target_user.first_name}!", "like_friend")
			Notification.notify(type: "like_friend", media: ['push'], people: [target_user], receivers: [user])
    end

    it 'match' do
      UrbanairshipWrapper.should_receive(:send).with([user], "Congrats! You've been matched with #{target_user.first_name}! Message now.", "match")
      UrbanairshipWrapper.should_receive(:send).with([target_user], "Congrats! You've been matched with #{user.first_name}! Message now.", "match")
      Notification.notify(type: "match", media: ['push'], people: [user, target_user], receivers: [user, target_user])
    end
	end
end