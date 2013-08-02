ActiveRecord::Base.transaction do
	Friendship.all.each do |model|
		p model.id
		tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
		model.chinchin_id = tempChinchin.user_id
		model.save
	end
	puts "Friendship ended"
end

ActiveRecord::Base.transaction do
	Like.all.each do |model|
		p model.id
		tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
		model.chinchin_id = tempChinchin.user_id
		model.save
	end
	puts "Like ended"
end

ActiveRecord::Base.transaction do
	View.all.each do |model|
		p model.id
		tempChinchin = TempChinchin.find_by_chinchin_id(model.viewee_id)
		model.viewee_id = tempChinchin.user_id
		model.save
	end
	puts "View ended"
end