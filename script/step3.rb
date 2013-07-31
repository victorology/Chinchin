Friendship.all.each do |model|
	p model.id
	tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
	if tempChinchin.nil?
		puts "doesn't exist #{model.id} - #{model.chinchin_id}"
	else
		model.chinchin_id = tempChinchin.user_id
		model.save
	end
end
puts "Friendship ended"

Like.all.each do |model|
	p model.id
	tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
	model.chinchin_id = tempChinchin.user_id
	model.save
end
puts "Like ended"

View.all.each do |model|
	p model.id
	tempChinchin = TempChinchin.find_by_chinchin_id(model.viewee_id)
	model.viewee_id = tempChinchin.user_id
	model.save
end
puts "View ended"

ProfilePhoto.all.each do |model|
	p model.id
	tempChinchin = TempChinchin.find_by_chinchin_id(model.chinchin_id)
	model.chinchin_id = tempChinchin.user_id
	model.save
end
puts "Profile Photos ended"