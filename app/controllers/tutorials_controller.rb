class TutorialsController < ApplicationController
	before_filter :check_for_mobile, :only => [:index]
  	before_filter :login_required

	def index
	end
end