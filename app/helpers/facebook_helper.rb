module FacebookHelper
	def user_likes_page
    me = FbGraph::User.me(user.oauth_token)
    page = FbGraph::Page.new(173946219392425) # or a Page retrieved using FbGraph::Page.search('fb_graph') as well
    @user_likes_page = me.like?(page) # true if User Liked, false otherwise
  end
end