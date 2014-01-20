class TimeUtil
  @@ts = nil

  def self.freeze(ts)
    @@ts = ts
  end

  def self.pass_by(delta)
    @@ts += delta
  end

  def self.get()
    if @@ts.nil?
      return Time.now
    else
      return @@ts
    end
  end

  def self.get_last_noon(time_zone='US/Pacific')
    Time.zone = time_zone
    zone_now = Time.zone.now
    if @@ts.nil?
      noon = Time.zone.local(zone_now.year, zone_now.month, zone_now.day, 12, 0)
      if Time.zone.now < noon
        noon = noon - 24.hours
      end
    else
      noon = Time.local(@@ts.year, @@ts.month, @@ts.day, 12, 0)
      if @@ts < noon
        noon = noon - 24.hours
      end
    end
    Time.zone = nil
    return noon
  end
end