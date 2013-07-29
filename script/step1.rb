puts `rake db:migrate:up VERSION=20130728105405`
User.update_all(status: User::REGISTERED)
puts `rake db:migrate:up VERSION=20130728111206`