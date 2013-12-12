require "spec_helper"

describe SessionsController do
  render_views

  before(:each) do
    User.delete_all
  end

  it "should return valid user data from facebook" do
    User.count.should == 0
    visit '/auth/facebook/callback?mobile=1'
    response.should render_template('tutorials/index')
    User.count.should == 1
    visit '/auth/facebook?mobile=1'
    response.should render_template('chinchins/index')
    User.count.should == 1
  end

  xit "authentication for api returns valid json" do
    stub_request(:post, "https://graph.facebook.com/oauth/access_token").
        with(:body => {"client_id"=>"352455024800701", "client_secret"=>"035385fe9e7db60eba187ab83fb27cb6", "fb_exchange_token"=>"token1234", "grant_type"=>"fb_exchange_token"},
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'Date'=>'Thu, 12 Dec 2013 08:07:39 GMT', 'User-Agent'=>'Rack::OAuth2 (1.0.7) (2.3.4.1, ruby 1.9.3 (2012-04-20))'}).
        to_return(:status => 200, :body => "", :headers => {})
    User.count.should == 0
    visit '/auth/facebook_access_token/callback'
    expect(response).to be_success
    User.count.should == 1
  end
end