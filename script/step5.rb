total_count = 0
total_temp = 100000

(3..14).to_a.each do |num|
	min = num * 100000 + 20000
	max = min + 100000
	sql = 'id >= ? and id < ?', min, max
	ActiveRecord::Base.transaction do
		p "start #{sql}"
		ProfilePhoto.where(sql).each do |model|
			total_count += 1

			tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
			model.chinchin_id = tempChinchin.user_id
			model.save

			if total_count % 10000 == 0
				p (total_count / total_temp.to_f * 100).round.to_s + "%"
			end
		end
		puts "Profile Photos ended - #{sql}, #{total_count}"
	end
end