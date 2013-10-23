class NotificationFacebook < NotificationMedia
  def notify()
    @options.each do |option|
      FbGraph::User.me(option[:user].oauth_token).app_request!(
          :message => option[:message],
          :data => nil
      )
    end
  end
end