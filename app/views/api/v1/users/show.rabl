object false
node (:status) { |m| 'ok' }
child(@user) {
  attributes :picture, :email, :uid, :name, :last_name, :first_name, :gender, :status, :id
  attribute :location, :if => lambda {|r| r.location.present?}
  attribute :employer, :if => lambda {|r| r.employer.present?}
  attribute :school, :if => lambda {|r| r.school.present?}
  attribute :age, :if => lambda {|r| r.age.present?}
  attribute :horoscope, :if => lambda {|r| r.horoscope.present?}

  node(:mutual_friends, :if => lambda { |m| m.id != @current_user.id }) do |m|
    m.mutual_friends(@current_user)
  end
  node(:friendship_count, :if => lambda { |m| m.friendships.present? }) do |m|
    m.friendships.count
  end
  node(:sorted_chinchin_count, :if => lambda { |m| m.sorted_chinchin.present? }) do |m|
    m.sorted_chinchin.count
  end
  node(:people_i_liked_count, :if => lambda { |m| m.likes.present? }) do |m|
    m.likes.count
  end
  node (:friendship_count) { |m| m.friendships.count }
  node (:friends_in_chinchin_count) { |m| m.friends_in_chinchin.count }
  child :profile_photos do
    attributes :source_url, :picture_url
  end
}
