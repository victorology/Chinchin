total_count = 0
total_temp = TempChinchin.count
ActiveRecord::Base.transaction do
	TempChinchin.all.each do |tempChinchin|
		total_count += 1
		ProfilePhoto.where('chinchin_id = ?', tempChinchin.chinchin_id).update_all({:chinchin_id => tempChinchin.user_id})

		if total_count % 1000 == 0
			p (total_count / total_temp.to_f * 100).round.to_s + "%"
		end
	end
	puts "Profile Photos ended"
end