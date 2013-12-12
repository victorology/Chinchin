class Currency < ActiveRecord::Base
  HEART = 0

  DEFAULT_COUNT = 5

  belongs_to :user
  has_many :currency_logs
  has_one :currency_alarm
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
    CurrencyAlarm.set(currency: self, type: CurrencyAlarm::HEART_IS_FULL_AGAIN)
  end

  def is_available
    self.current_count > 0
  end

  def last_used_log
    recent_cl = self.currency_logs.where('action in (?)', ['regen', 'regen_full', 'recharge_full']).order('created_at DESC').first
    if recent_cl.nil?
      cl = self.currency_logs.where('action = ?', 'use').order('created_at').first
    elsif recent_cl.action == 'regen_full' or recent_cl.action == 'recharge_full'
      regen_cl = self.currency_logs.where('action = ? and created_at >= ?', 'regen', recent_cl.created_at).order('created_at DESC').first
      if regen_cl
        cl = regen_cl
      else
        cl = self.currency_logs.where('action = ? and created_at >= ?', 'use', recent_cl.created_at).order('created_at').first
        if cl.nil?
          cl = recent_cl
        end
      end
    elsif recent_cl.action == 'regen'
      cl = recent_cl
    end
    return cl
  end

  def recalculate
    if self.current_count == self.max_count
      return
    end

    log = self.last_used_log
    if log.nil?
      return
    end

    now = TimeUtil.get
    delta = (now - log.created_at).round.to_f

    regen_count = (delta / (60 * 30)).to_i
    if regen_count >= (self.max_count - self.current_count)
      regen_count = self.max_count - self.current_count
      CurrencyLog.create(currency: self, action: 'regen_full', value: regen_count)
    elsif regen_count > 0
      CurrencyLog.create(currency: self, action: 'regen', value: regen_count)
    end

    self.current_count += regen_count
    self.save
  end

  def active_alarm
    return self.currency_alarm if self.currency_alarm and self.currency_alarm.is_active
  end

  def recharge_full(via="system")
    regen_count = self.max_count - self.current_count
    self.current_count = self.max_count
    self.save
    CurrencyLog.create(currency: self, action: 'recharge_full', value: regen_count, via: via)
  end
end