class ContactsController < ApplicationController
  layout false
  before_filter :admin_login_required, :set_admin_locale

	def show
		user_id = params[:id]
    @user = User.find(user_id)
    @contacts = Contact.where('user_id = ? and phone_number is not null', user_id)
  end
end