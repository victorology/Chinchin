class ChinchinsController < ApplicationController
	def show
		@chinchin = Chinchin.find(params[:id])
	end
end