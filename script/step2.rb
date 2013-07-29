puts `rake db:migrate:up VERSION=20130705111521`

saved_count = 0
failed_count = 0

Chinchin.all.each do |chinchin|
  attrs = chinchin.attributes

  user_id = attrs["user_id"]
  attrs.delete("id")
  attrs.delete("user_id")

  if user_id.nil?
    saved_count += 1
    user = User.new
    attrs.keys.each do |k, v|
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
    failed_count += 1
  end
end

puts "saved_count #{saved_count}"
puts "faild_count #{failed_count}"