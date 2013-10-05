class Currency < ActiveRecord::Base
  HEART = 0

  DEFAULT_COUNT = 5

  belongs_to :user
  has_many :currency_logs
  # attr_accessible :title, :body

  def self.init(user, currency_type)
    c = Currency.new
    c.user = user
    c.max_count = DEFAULT_COUNT # TODO: must be configurable
    c.current_count = DEFAULT_COUNT # TODO: must be configurable
    c.currency_type = currency_type
    c.save

    if c
      CurrencyLog.create(currency: c, action: 'init', value: 5)
    end

    return c
  end

  def use(value)
    self.current_count -= value
    self.save

    CurrencyLog.create(currency: self, action: 'use', value: -1)
  end

  def is_available
    self.current_count > 0
  end

  def last_used_log
    regen_cl = self.currency_logs.where('action = ?', 'regen').order('created_at DESC').first

    if regen_cl
      cl = self.currency_logs.where('action = ? and created_at > ?', 'use', regen_cl.created_at).order('created_at').first
      if cl.nil?
        cl = regen_cl
      end
    else
      cl = self.currency_logs.where('action = ?', 'use').order('created_at').first
    end

    return cl
  end

  def recalculate
    if self.current_count == self.max_count
      return
    end

    log = self.last_used_log

    now = TimeUtil.get
    delta = now - log.created_at

    regen_count = (delta / (60 * 30)).to_i
    if regen_count > (self.max_count - self.current_count)
      regen_count = self.max_count - self.current_count
    end

    self.current_count += regen_count

    self.save

    if regen_count > 0
      CurrencyLog.create(currency: self, action: 'regen', value: regen_count)
    end
  end
end