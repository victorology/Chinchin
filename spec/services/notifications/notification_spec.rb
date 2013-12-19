# require 'spec_helper'
require_relative '../../../app/services/notification'
require_relative '../../../app/services/notification_media'
require_relative '../../../app/services/notification_push'
require_relative '../../../app/services/notification_email'
require_relative '../../../app/services/notification_feed'
require_relative '../../../app/services/notification_string'
require 'active_support/all'

describe Notification do
	let(:user) {stub(:user, id: 100, status: 1, first_name: "Charlie", name: "Charlie Kim", uid: "12345")}
	let(:target_user) {stub(:user, id: 101, status: 1, first_name: "Eunmi", name: "Eunmi Lee", uid: "5678")}
	let(:friend1) {stub(:user, id: 102, status: 1)}
	let(:friend2) {stub(:user, id: 103, status: 1)}
	# let(:user) { stub(:user, id: 100, status: 1) }
	# let(:chinchin) { stub(:user, id: 200, name: "name first_name", first_name: "first_name", registered_friends: [], status: 1) }

	context '.notify with type' do
		it 'notify with push type should trigger notification_push.notify' do
			NotificationPush.any_instance.should_receive(:notify)
			Notification.notify(type: "like", media: ['push'], receivers: [friend1, friend2])
		end

		it 'notify with email type should trigger notification_email.notify' do
			NotificationEmail.any_instance.should_receive(:notify)
			Notification.notify(type: "like", media: ['email'], receivers: [friend1, friend2])
		end

		it 'notify with feed type should trigger notification_feed.notify' do
			NotificationFeed.any_instance.should_receive(:notify)
			Notification.notify(type: "like", media: ['feed'], receivers: [friend1, friend2])
		end

		it 'notify with prepare when type is not match' do
			NotificationFeed.any_instance.should_receive(:prepare)
			NotificationFeed.any_instance.should_receive(:notify)
			Notification.notify(type: "match_friend", media: ['feed'], receivers: [friend1, friend2])
		end

		it 'notify with prepare_for_match when type is match' do
			NotificationFeed.any_instance.should_receive(:prepare_for_match)
			NotificationFeed.any_instance.should_receive(:notify)
			Notification.notify(type: "match", media: ['feed'], people: [user, target_user], receivers: [user, target_user])
		end

		it 'notify with push type should trigger UrbanairshipWrapper.send' do
			NotificationPush.any_instance.should_receive(:prepare)
			NotificationPush.any_instance.should_receive(:notify)
			Notification.notify(type: "like", media: ['push'], receivers: [friend1, friend2])
		end
	end
end