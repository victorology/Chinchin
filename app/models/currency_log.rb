class CurrencyLog < ActiveRecord::Base
  belongs_to :currency
  attr_accessible :currency, :action, :value
  after_create {
    self.created_at = TimeUtil.get
    self.save
  }
end
