puts `rake db:migrate:up VERSION=20130728111521`

new_count = 0
existed_count = 0

Chinchin.all.each do |chinchin|
  attrs = chinchin.attributes

  p chinchin.id

  user_id = attrs["user_id"]
  attrs.delete("id")
  attrs.delete("user_id")

  if user_id.nil?
    new_count += 1
    user = User.new
    attrs.each do |k, v|
      user.send("#{k}=", v)
    end

    if user.save
      tu = TempChinchin.new
      tu.user_id = user.id
      tu.chinchin_id = chinchin.id
      tu.save
    else
      puts user.errors.full_messages
    end
  else
    existed_count += 1
    tu = TempChinchin.new
    tu.user_id = user_id
    tu.chinchin_id = chinchin.id
    tu.save
  end
end

puts "New from chinchin #{new_count}"
puts "Already existed user #{existed_count}"