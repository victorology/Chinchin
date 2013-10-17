require_relative '../../../app/services/notification_string'
require 'active_support/all'

describe NotificationString do
	let(:person1) { stub(:user, first_name: "Charlie") }
	let(:person2) { stub(:user, first_name: "Eunmi") }

	context '.message with like type' do
		it '.' do
			NotificationString.message(type: "like").should == "Someone likes you!"
		end
	end

	context '.message with like_friend type' do
		it '.' do
			NotificationString.message(type: "like_friend", people: [person1]).should == "Someone likes Charlie!"
		end

		it 'raise error when there is no people data' do
			NotificationString.message(type: "like_friend").should == nil
		end
	end

	context '.message with alert type' do
		it '.' do
			NotificationString.message(type: "alert", people: [person1, person2]).should == "Charlie likes Eunmi!"
		end

		it 'raise error when there is no people data' do
			NotificationString.message(type: "alert").should == nil
		end
	end

	context '.message with match type' do
		it '.' do
			NotificationString.message(type: "match", people: [person1, person2]).should == [
				"Congrats! You've been matched with Eunmi! Message now.",
				"Congrats! You've been matched with Charlie! Message now."
			]
		end

		it 'raise error when there is no people data' do
			NotificationString.message(type: "match").should == nil
		end
	end

	context '.message with match_friend type' do
		it '.' do
			NotificationString.message(type: "match_friend").should == "Two of your friends are a match!"
		end
	end

	context '.message with unknown type' do
		it '.' do
			NotificationString.message(type: "unknown").should == nil
		end
  end

  context '.message with currency' do
    it '.' do
      NotificationString.message(type: "heart_full").should == "You have a full set of hearts. See more Chinchins!"
    end
  end
end