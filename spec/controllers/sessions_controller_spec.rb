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

  it "authentication for api returns valid json" do
    User.count.should == 0
    visit '/auth/facebook_access_token/callback'
    expect(response).to be_success
    User.count.should == 1
  end
end