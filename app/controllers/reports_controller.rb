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
		csv = "Day,New Male User,New Female User,New Male Chinchin,New Female Chinchin,New Like From Male,New Like From Female,Unique Daily Like From Male,Unique Daily Like From Female,Total Unique Like From Male,Total Unique Like From Female,User has no chinchins,User has one chinchin,User has two chinchins,User has three or more chinchins"

		@results = Report.make_reports('2013-01-01'.to_date, Time.now.to_date)

		@results.each do |result|
			items = []
			d = result[1]
			keys = ['male_users', 'female_users', 'male_chinchins', 'female_chinchins', 'likes_from_male', 'likes_from_female', 'uniq_male_liked', 'uniq_female_liked', 'total_uniq_male_liked', 'total_uniq_female_liked', 'no_chinchins', 'one_chinchin', 'two_chinchins', 'three_more_chinchins']
			keys.each do |key|
				items << d[key]
			end
			row = result[0] + "," + items.join(",")
			csv += "\n" + row
		end

		render text: csv
	end
end