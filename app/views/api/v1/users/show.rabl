object false
node (:status) { |m| 'ok' }
child(@current_user) {
  attributes :uid, :name, :last_name, :first_name, :email, :location, :hometown, :birthday, :employer, :position, :gender, :school, :status
  node (:friendship_count) { |m| @current_user.friendships.count }
  node (:friends_in_chinchin_count) { |m| @current_user.friends_in_chinchin.count }
  node (:sorted_chinchin_count) { |m| @current_user.sorted_chinchin.count }
  child :profile_photos do
    attributes :source_url, :picture_url
  end
}
