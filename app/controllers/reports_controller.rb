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
		@results = Report.total_user_per_day(started_at, ended_at)
		
		render json: @results
	end
end