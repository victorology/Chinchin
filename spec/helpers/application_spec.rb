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
    c.last_used_log.created_at.should eq now
    currency_timeleft(@user, Currency::HEART).should == 60*1*1000
  end

  it 'currency_timeleft after recalculate' do
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(0)
    TimeUtil.pass_by(60*5)
    c.use(1)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of((30*60) * 1000)
    TimeUtil.pass_by(60*5)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(((30*60) - (5*60)) * 1000)
    TimeUtil.pass_by(60*24)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(((30*60) - (29*60)) * 1000)
    TimeUtil.pass_by(60*1)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(0)
  end

  it 'currency_timeleft after recalculate with multiple use' do
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    TimeUtil.pass_by(60*5)
    c.use(1)
    TimeUtil.pass_by(60*10)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(((30*60) - (10*60)) * 1000)
    TimeUtil.pass_by(60*5)
    c.use(1)
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(((30*60) - (15*60)) * 1000)
    TimeUtil.pass_by(60*20)
    c.recalculate
    currency_timeleft(@user, Currency::HEART).should be_within(1000).of(((30*60) - (5*60)) * 1000)
  end
end