require "spec_helper"

describe "SessionController" do
  before(:each) do
    #request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    User.delete_all
  end

  it "should return valid user data from facebook" do
    User.count.should == 0
    visit '/auth/facebook?mobile=1'
    response.should render_template('tutorials/index')
    User.count.should == 1
    visit '/auth/facebook?mobile=1'
    response.should render_template('chinchins/index')
    User.count.should == 1
  end
end