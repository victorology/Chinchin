object false
node (:status) { |m| 'ok' }
child(@chinchin) {
  attributes :picture, :uid, :name, :last_name, :first_name, :gender, :status, :id
  attribute :bio, :if => lambda {|r| r.bio.present?}
  attribute :quotes, :if => lambda {|r| r.quotes.present?}
  attribute :location, :if => lambda {|r| r.location.present?}
  attribute :employer, :if => lambda {|r| r.employer.present?}
  attribute :school, :if => lambda {|r| r.school.present?}
  attribute :age, :if => lambda {|r| r.age.present?}
  attribute :horoscope, :if => lambda {|r| r.horoscope.present?}
  node (:friendship_count) { |m| @chinchin.friendships.count }
  node (:mutual_friends) { |m| @chinchin.mutual_friends(@current_user) }
  node (:current_heart_count) { |m| @current_user.currency(Currency::HEART).current_count }
  child :profile_photos do
    attributes :source_url, :picture_url
  end
}
