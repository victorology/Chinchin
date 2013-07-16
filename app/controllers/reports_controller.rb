class ReportsController < ApplicationController
	layout false

	def index
		started_at = 90.days.ago.beginning_of_day
		ended_at = Time.now
		@total_user_count = Report.total_user_per_day(started_at, ended_at)
		@dates = ((started_at.to_date) .. (ended_at.to_date))
	end

	def show
		started_at = params[:started_at].to_date
		ended_at = params[:ended_at].to_date
		@chinchins = Report.count_chinchins_per_day(started_at, ended_at)
		@users = Report.total_user_per_day(started_at, ended_at)
		@users.keys.inspect
		@results = {}
		@chinchins.keys.each do |key|
			c = @chinchins[key]
			u = @users[key]
			if u.nil?
				u = {'total'=>0, 'male'=>0, 'female'=>0}
			end
			@results[key] = c.merge(u)
		end

		render json: @results
	end
end