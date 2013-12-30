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
    User.any_instance.should_receive(:renew_credential)
    User.count.should == 0
    visit '/auth/facebook_access_token/callback/'
    JSON.parse(page.source)["status"].should == "created"
    User.count.should == 1
  end

  it "second authentication should return ok" do
    FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '1234', status: 1)

    User.any_instance.should_receive(:renew_credential)
    User.count.should == 1
    visit '/auth/facebook_access_token/callback/'
    JSON.parse(page.source)["status"].should == "ok"
    User.count.should == 1
  end
end