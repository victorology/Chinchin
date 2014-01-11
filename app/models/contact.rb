class Contact < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :first_name, :last_name, :phone_number, :email, :facebook_uid, :facebook_username, :twitter_username
end