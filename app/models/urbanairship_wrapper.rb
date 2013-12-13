class UrbanairshipWrapper < ActiveRecord::Base
  def self.send(users, message, type="info")
    begin
      device_tokens = users.map { |user| user.device_token }.compact
    rescue
      device_tokens = []
    end

    if device_tokens.count > 0
      notification = {
          :device_tokens => device_tokens,
          :aps => {:alert => message, :badge => 1},
          :type => type
      }

      Urbanairship.push(notification)
    end

    begin
      apids = users.map { |user| user.apid }.compact
    rescue
      apids = []
    end

    if apids.count > 0
      notification = {
          :apids => apids,
          :android => {:alert => message}
      }

      Urbanairship.push(notification)
    end
  end
end