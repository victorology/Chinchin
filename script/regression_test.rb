require 'yaml'

ids = [6, 295, 588]

result = ids.map do |id|
	u = User.find(id)
	u_friends = u.chinchins.map(&:uid).sort
	u_likes = u.likes.map { |like| like.chinchin.uid }.sort
	hash = {}
	hash[id.to_s] = { friends: u_friends,
										likes: u_likes }
	hash
end

if File.exist?('regression_data.yaml')
	loaded_data = YAML.load(File.read('regression_data.yaml'))
	puts 'Already exist. Compare Result'
	puts result == loaded_data
else
	puts 'Not exist regression file. Now creating...'
	File.open('regression_data.yaml', 'w') do |file|
		file << YAML.dump(result)
	end
end