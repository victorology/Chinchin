require 'spec_helper'

describe Currency do
  before(:each) do
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
  end

  after(:each) do
    Currency.delete_all
  end

  it 'belongs to user' do
    @user.currencies.count.should eq 0

    c = Currency.new
    c.user = @user
    c.max_count = 5
    c.current_count = 5
    c.save

    @user.currencies.count.should == 1
  end

  it 'should be invoked init when user trying to use it for the first time ' do
    Currency.should_receive(:init).with(@user, Currency::HEART).and_call_original
    @user.use_currency(Currency::HEART)
  end

  it 'should be initialized (5) when user trying to access it' do
    c = @user.currency(Currency::HEART)
    c.current_count.should == 5
  end

  it 'should can be used when user trying to use it for the first time' do
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should == 4
  end

  it 'should not be available when it is empty' do
    @user.currency(Currency::HEART).current_count.should eq 5
    @user.currency(Currency::HEART).is_available.should eq true
    @user.use_currency(Currency::HEART)
    @user.use_currency(Currency::HEART)
    @user.use_currency(Currency::HEART)
    @user.use_currency(Currency::HEART)
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 0
    @user.currency(Currency::HEART).is_available.should == false
  end

  it 'should not be used when it is empty' do
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 4
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 3
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 2
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 1
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 0
    @user.use_currency(Currency::HEART)
    @user.currency(Currency::HEART).current_count.should eq 0
  end

  it 'should be initialized via CurrencyLog' do
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'init', value: 5).and_call_original
    Currency.init(@user, Currency::HEART)
  end

  it 'should return nil when it attempt to get last log after last regen the very next to init' do
    c = Currency.init(@user, Currency::HEART)
    c.last_used_log.should be_nil
  end

  it 'should return valid log after use it' do
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    c.last_used_log.should_not be_nil
    c.last_used_log.value.should == -1
    c.last_used_log.action.should == 'use'
  end

  it 'should return nil when it never be used after regen' do
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    cl = CurrencyLog.create(currency:c, action: 'regen', value: 1)
    c.last_used_log.should eq cl
  end

  it 'should return log the very after regen log when it used after regen' do
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    cl = CurrencyLog.create(currency:c, action: 'regen', value: 1)
    c.use(1)
    c.last_used_log.should_not be_nil
    c.last_used_log.should_not eq cl.created_at
    c.last_used_log.action.should == 'use'
    c.last_used_log.value.should == -1
  end

  it 'last_log should return last generated log when last used log is not exist since last generated' do
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    c.last_used_log.should be_nil
    c.use(1)
    c.last_used_log.created_at.should eq TimeUtil.get
    TimeUtil.pass_by(60*30)
    c.current_count.should == 4
    c.recalculate
    c.last_used_log.created_at.should eq TimeUtil.get
    c.current_count.should == 5
    TimeUtil.pass_by(60)
    c.use(1)
    TimeUtil.pass_by(30)
    c.use(1)
    c.last_used_log.created_at.should eq TimeUtil.get - 30
    TimeUtil.pass_by(60*30)
    c.recalculate
    c.current_count.should == 4
    c.last_used_log.created_at.should eq TimeUtil.get
  end

  it 'should regenerate 1 heart after time passed by 30 min' do
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'init', value: Currency::DEFAULT_COUNT).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'regen', value: 1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'regen', value: 3).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'regen', value: 1).and_call_original
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    TimeUtil.pass_by(60*30)
    c.current_count.should == 4
    c.recalculate
    c.current_count.should == 5

    c.use(1)
    c.use(1)
    c.use(1)
    c.current_count.should == 2
    TimeUtil.pass_by(60*30*3)
    c.recalculate
    c.current_count.should == 5
    c.use(1)
    TimeUtil.pass_by(60*30*3)
    c.recalculate
    c.current_count.should == 5
  end

  it 'should not regenerate heart within 30 min' do
    now = Time.now
    TimeUtil.freeze(now)
    c = Currency.init(@user, Currency::HEART)
    c.use(1)
    TimeUtil.pass_by(60*29)
    c.current_count.should == 4
    c.recalculate
    c.current_count.should == 4
  end
end