class ReportsController < ApplicationController
	layout false
	before_filter :admin_login_required

	def index
		started_at = 90.days.ago.beginning_of_day
		ended_at = Time.now
		@total_user_count = Report.total_user_per_day(started_at, ended_at)
		@dates = ((started_at.to_date) .. (ended_at.to_date))
	end

	def show
		started_at = params[:started_at].to_date
		ended_at = params[:ended_at].to_date
		@results = Report.make_reports(started_at, ended_at)

		render json: @results
	end

	def csv		
		csv = "Day, \
		Members (Daily),Male Members (Daily), Female Members (Daily), \
		Chinchins (Daily),Male Chinchins (Daily),Female Chinchins (Daily), \
		Likes (Daily),Likes sent by Male (Daily),Likes sent by Female (Daily), \
		Mutual Likes (Total), \
		Likes sent by Unique Male (Daily),Likes sent by Unique Female (Daily), \
		Likes sent by Unique Male (Total),Likes sent by Unique Female (Total), \
		Likes received by Unique Male (Daily), Likes received by Unique Female (Daily), \
		Male Members w/no Chinchin,Female Members w/no Chinchin, \
		Male Members w/1 Chinchin,Female Members w/1 Chinchin, \
		Male Members w/2 Chinchins,Female Members w/2 Chinchins, \
		Male Members w/3+ Chinchins, Female Members w/3+ Chinchins"

		@results = Report.make_reports('2013-01-01'.to_date, Time.now.to_date)

		@results.each do |result|
			items = []
			d = result[1]
			keys = ['total_users', 'male_users', 'female_users', 
				'total_chinchins', 'male_chinchins', 'female_chinchins', 
				'total_likes', 'likes_from_male', 'likes_from_female', 
				'total_mutual_likes', 
				'uniq_male_liked', 'uniq_female_liked', 
				'total_uniq_male_liked', 'total_uniq_female_liked', å
				'uniq_male_received_like', 'uniq_female_received_like', 
				'male_no_chinchins', 'female_no_chinchins', 
				'male_one_chinchin', 'female_one_chinchin', 
				'male_two_chinchins', 'female_two_chinchins', 
				'male_three_more_chinchins', 'female_three_more_chinchins',
			]
			keys.each do |key|
				items << d[key]
			end
			row = result[0] + "," + items.join(",")
			csv += "\n" + row
		end

		render text: csv
	end
end