object false
node (:status) { |m| 'ok' }
child(@chinchin) {
  attributes :picture, :uid, :name, :last_name, :first_name, :email, :location, :hometown, :birthday, :employer, :position, :gender, :school, :status
  node (:friendship_count) { |m| @chinchin.friendships.count }
  node (:mutual_friends) { |m| @chinchin.mutual_friends(@current_user) }
  node (:current_heart_count) { |m| @current_user.currency(Currency::HEART).current_count }
  child :profile_photos do
    attributes :source_url, :picture_url
  end
}
