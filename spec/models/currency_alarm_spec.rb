require 'spec_helper'

describe CurrencyAlarm do
  before(:each) do
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
    CurrencyAlarm.delete_all
  end

  after(:each) do

  end

  context 'type is HEART_IS_FULL_AGAIN' do
    it 'should be created when any heart is used' do
      CurrencyAlarm.count.should == 0
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
      CurrencyAlarm.last.alarm_type = CurrencyAlarm::HEART_IS_FULL_AGAIN
      CurrencyAlarm.last.currency.user.should eq @user
      CurrencyAlarm.last.currency.currency_type.should == Currency::HEART
    end

    it 'should be updated when there was a currency alarm' do
      CurrencyAlarm.count.should == 0
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
      CurrencyAlarm.last.alarm_type = CurrencyAlarm::HEART_IS_FULL_AGAIN
      CurrencyAlarm.last.currency.user.should eq @user
      CurrencyAlarm.last.currency.currency_type.should == Currency::HEART

      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
    end

    it 'should set set_at with 30min after when currency is last used' do
      now = Time.now
      TimeUtil.freeze(now)
      CurrencyAlarm.count.should == 0
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
      CurrencyAlarm.last.alarm_type = CurrencyAlarm::HEART_IS_FULL_AGAIN
      CurrencyAlarm.last.currency.user.should eq @user
      CurrencyAlarm.last.set_at.should eq now + 30*60
      CurrencyAlarm.last.currency.currency_type.should == Currency::HEART
    end

    it 'should set set_at with 40min after when currency is last used' do
      now = Time.now
      TimeUtil.freeze(now)
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.last.set_at.should eq now + 30*60
      TimeUtil.pass_by(10*60)
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.last.set_at.should eq now + 60*60
      TimeUtil.pass_by(55*60)
    end

    it 'should be nil when heart are already full' do
      @user.currency(Currency::HEART).active_alarm.should be_nil
      now = Time.now
      TimeUtil.freeze(now)
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
      TimeUtil.pass_by(29*60)
      CurrencyAlarm.check_and_ring
      @user.currency(Currency::HEART).active_alarm.should be_nil
      TimeUtil.pass_by(1*60)
      @user.currency(Currency::HEART).active_alarm.should be_valid
      @user.currency(Currency::HEART).active_alarm.set_at.should eq now + (30*60)
      CurrencyAlarm.check_and_ring
      @user.currency(Currency::HEART).active_alarm.should be_nil
    end

    it 'should send notification when it rings' do
      Notification.should_receive(:notify).with(type: "heart_full", media: ['push', 'feed'], receivers: [@user])
      @user.currency(Currency::HEART).active_alarm.should be_nil
      now = Time.now
      TimeUtil.freeze(now)
      @user.use_currency(Currency::HEART)
      CurrencyAlarm.count.should == 1
      TimeUtil.pass_by(30*60)
      CurrencyAlarm.check_and_ring
    end
  end
end
