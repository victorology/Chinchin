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
end