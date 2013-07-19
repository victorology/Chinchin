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
		# @chinchins = Report.count_chinchins_per_day(started_at, ended_at)
		@users = Report.total_user_per_day(started_at, ended_at)
		# @users.default = {'total_users'=>0, 'male_users'=>0, 'female_users'=>0}
		@likes = Report.total_like_per_day(started_at, ended_at)
		# @likes.default = {'total_likes'=>0, 'likes_from_male'=>0, 'likes_from_female'=>0}
		@uniq_likes = Report.total_like_per_day(started_at, ended_at)
		# @uniq_likes.default = {'uniq_male_liked'=>0, 'uniq_female_liked'=>0}
		@chinchins = Report.total_chinchin_per_day(started_at, ended_at)

		keys = @users.keys

		@results = {}
		keys.each do |key|
			u = @users[key]
			l = @likes[key]
			q = @uniq_likes[key]
			c = @chinchins[key]
			@results[key] = u.merge(l).merge(q).merge(c)
		end

		# render json: @results
		render json: @results
	end
end