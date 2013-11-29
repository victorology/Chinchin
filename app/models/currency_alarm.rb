class CurrencyAlarm < ActiveRecord::Base
  belongs_to :currency

  HEART_IS_FULL_AGAIN = 0

  PENDING = 0
  ALARMED = 1

  def self.set(options)
    currency = options[:currency]
    alarm_type = options[:type]

    currency_alarm = CurrencyAlarm.where('currency_id = ? and alarm_type = ?', currency.id, alarm_type).last

    if currency_alarm.nil?
      currency_alarm = CurrencyAlarm.new
      currency_alarm.currency = currency
      currency_alarm.alarm_type = alarm_type
      currency_alarm.status = CurrencyAlarm::PENDING
    elsif currency_alarm.status == ALARMED
      currency_alarm.status = CurrencyAlarm::PENDING
    end

    heart_gap = currency.max_count - currency.current_count
    if heart_gap <= 0
      return
    end
    currency_alarm.set_at = currency.last_used_log.created_at + (30*60*heart_gap)
    currency_alarm.save
  end

  def is_active
    self.set_at <= TimeUtil.get and self.status == CurrencyAlarm::PENDING
  end

  def self.active_alarms
    CurrencyAlarm.where('set_at <= ? and status = ?', TimeUtil.get, CurrencyAlarm::PENDING)
  end

  def self.check_and_ring
    alarmed_user = []
    for alarm in CurrencyAlarm.active_alarms
      currency = alarm.currency
      currency.recalculate
      if currency.max_count == currency.current_count
        alarmed_user.push(currency.user)
        alarm.status = CurrencyAlarm::ALARMED
        alarm.save
      end
    end

    Notification.notify(type: "heart_full", media: ['push'], receivers: alarmed_user)
  end
end
