puts `rake db:migrate:up VERSION=20130705105405`
User.update_all(status: User::REGISTERED)
puts `rake db:migrate:up VERSION=20130705111206`