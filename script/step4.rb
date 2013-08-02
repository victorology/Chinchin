empty_counter = 0
total_counter = 0
total_friendship = Friendship.count
Friendship.all.each do |friendship|
	if Friendship.where('user_id = ? and chinchin_id = ?', friendship.chinchin_id, friendship.user_id).empty?
		f = Friendship.new
		f.user_id = friendship.chinchin_id
		f.chinchin_id = friendship.user_id
		f.save
	end
	total_counter += 1
	if total_counter % 1000 == 0
		p (total_counter / total_friendship.to_f * 100).round.to_s + "%"
	end
end