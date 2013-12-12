class CurrencyLog < ActiveRecord::Base
  belongs_to :currency
  attr_accessible :currency, :action, :value, :via
  before_create {
    @last_used_log = self.currency.last_used_log
  }
  after_create {
    if self.action == 'regen' and not @last_used_log.nil?
      self.created_at = @last_used_log.created_at + (30 * 60 * self.value)
    else
      self.created_at = TimeUtil.get
    end
    self.save
  }
end
