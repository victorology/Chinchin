class Jump < ActiveRecord::Base
  belongs_to :user, touch: true
  attr_accessible :user, :from, :to
end
