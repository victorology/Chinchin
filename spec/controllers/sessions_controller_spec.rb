require "spec_helper"

describe SessionsController do
  render_views

  before(:each) do
    User.delete_all
    Delayed::Worker.delay_jobs = false
  end

  it "should return valid user data from facebook" do
    friend = FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '7890', status: 6)
    chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'female', status: 6)
    chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'female', status: 0)
    User.any_instance.stub(:friends_at_once) { [] }
    User.any_instance.stub(:friends_in_chinchin) { [friend] }
    User.any_instance.stub(:photos) { [] }
    friend.stub(:friends_in_chinchin) { [chinchin_1] }
    friend.stub(:chinchins) { [chinchin_1, chinchin_2] }
    User.count.should == 3
    visit '/auth/facebook/callback?mobile=1'
    response.should render_template('tutorials/index')
    User.last.status.should == 6
    User.count.should == 4
    visit '/auth/facebook?mobile=1'
    response.should render_template('chinchins/index')
    User.count.should == 4
  end

  it "authentication for api returns valid json" do
    User.any_instance.should_receive(:renew_credential)
    User.any_instance.stub(:friends_at_once) { [] }
    User.any_instance.stub(:photos) { [] }
    User.count.should == 0
    visit '/auth/facebook_access_token/callback/'
    JSON.parse(page.source)["status"].should == "created"
    User.count.should == 1
  end

  it "second authentication (without chinchin) should return created" do
    FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '1234', status: 1)
    User.any_instance.should_receive(:renew_credential)
    User.any_instance.stub(:friends_at_once) { [] }
    User.any_instance.stub(:photos) { [] }
    User.count.should == 1
    visit '/auth/facebook_access_token/callback/'
    JSON.parse(page.source)["status"].should == "created"
    User.count.should == 1
  end

  it "second authentication (with chinchin) should return ok" do
    FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '1234', status: 6)
    friend = FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '7890', status: 6)
    chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'female', status: 6)
    chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'female', status: 0)
    User.any_instance.stub(:friends_at_once) { [] }
    User.any_instance.stub(:friends_in_chinchin) { [friend] }
    User.any_instance.stub(:photos) { [] }
    friend.stub(:friends_in_chinchin) { [chinchin_1] }
    friend.stub(:chinchins) { [chinchin_1, chinchin_2] }
    User.any_instance.should_receive(:renew_credential)
    User.count.should == 4
    visit '/auth/facebook_access_token/callback/'
    JSON.parse(page.source)["status"].should == "ok"
    User.count.should == 4
  end

  context 'User registered_at' do
    it 'set registered_at with registered' do
      now = Time.new(2014, 1, 5, 0, 0, 0)
      TimeUtil.freeze(now)
      TimeUtil.pass_by(60*30)
      FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '1234', status: 0)
      User.any_instance.should_receive(:renew_credential)
      User.any_instance.stub(:friends_at_once) { [] }
      User.any_instance.stub(:photos) { [] }
      User.count.should == 1
      visit '/auth/facebook_access_token/callback/'
      JSON.parse(page.source)["status"].should == "created"
      User.count.should == 1
      User.first.registered_at.should eq Time.new(2014, 1, 5, 0, 30, 0)
    end
  end

  context 'No found chinchin' do
    it 'should set NO_FOUND_CHINCHINS to user status' do
      User.any_instance.should_receive(:renew_credential)
      User.any_instance.should_receive(:update_from_omniauth).and_call_original
      User.any_instance.should_receive(:add_friends_to_chinchin).and_call_original
      User.any_instance.should_receive(:generate_sorted_chinchin).and_call_original
      User.any_instance.stub(:friends_at_once) { [] }
      User.any_instance.stub(:photos) { [] }
      visit '/auth/facebook_access_token/callback/'
      JSON.parse(page.source)["status"].should == "created"
      User.count.should == 1
      User.first.status.should == User::NO_FOUND_CHINCHINS_ONBOARDING
    end

    it 'should found chinchin' do
      friend = FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '7890', status: 6)
      chinchin = FactoryGirl.create(:user, name: 'lee', gender: 'female', provider: 'facebook_access_token', uid: '5678', status: 0)
      User.any_instance.should_receive(:renew_credential)
      User.any_instance.should_receive(:make_sorted_chinchin).and_call_original
      User.any_instance.should_receive(:generate_sorted_chinchin).and_call_original
      User.any_instance.stub(:friends_at_once) { [] }
      User.any_instance.stub(:photos) { [] }
      User.any_instance.stub(:friends_in_chinchin) { [friend] }
      friend.stub(:friends_in_chinchin) { [chinchin] }
      visit '/auth/facebook_access_token/callback/'
      JSON.parse(page.source)["status"].should == "created"
      User.count.should == 3
      User.last.status.should == User::FOUND_CHINCHINS
    end

    it 'should update to found from not found' do
      friend = FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '7890', status: User::NO_FOUND_CHINCHINS)
      User.any_instance.should_receive(:renew_credential)
      User.any_instance.should_receive(:jump).and_call_original
      User.any_instance.stub(:photos) { [] }
      friend_mock = {'uid' => '7890'}
      User.any_instance.stub(:friends_at_once) { [friend_mock] }
      OpenStruct.any_instance.stub(:fetch) { friend_mock }

      friend.status.should == User::NO_FOUND_CHINCHINS
      visit '/auth/facebook_access_token/callback/'
      expect(User.where('uid = ?', '7890').first.status).to equal(User::FOUND_CHINCHINS)
    end

    it 'should notify about new friends' do
      friend = FactoryGirl.create(:user, name: 'kim', gender: 'male', provider: 'facebook_access_token', uid: '7890', status: User::NO_FOUND_CHINCHINS)
      User.any_instance.should_receive(:renew_credential)
      UrbanairshipWrapper.should_receive(:send).with([friend], "Test Kim joined Chinchin!", "friend_join", nil)
      User.any_instance.should_receive(:jump).and_call_original
      User.any_instance.stub(:photos) { [] }
      friend_mock = {'uid' => '7890'}
      User.any_instance.stub(:friends_at_once) { [friend_mock] }
      OpenStruct.any_instance.stub(:fetch) { friend_mock }

      friend.status.should == User::NO_FOUND_CHINCHINS
      visit '/auth/facebook_access_token/callback/'
    end
  end
end