require 'spec_helper'

describe ApplicationHelper do
  before(:each) do
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
  end

  after(:each) do
  end

  it 'currency_timeleft' do
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    TimeUtil.pass_by(60*29)
  end
end