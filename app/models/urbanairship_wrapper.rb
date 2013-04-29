class UrbanairshipWrapper < ActiveRecord::Base
  def self.send(users, message)
    begin
      device_tokens = users.map { |user| user.device_token }.compact
    rescue
      device_tokens = []
    end

    if device_tokens.count > 0
      notification = {
          :device_tokens => device_tokens,
          :aps => {:alert => message, :badge => 1}
      }

      Urbanairship.push(notification)
    end
  end
end