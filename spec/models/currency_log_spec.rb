require 'spec_helper'

describe CurrencyLog do
  before(:each) do
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
  end

  after(:each) do
  end

  it 'should be belongs to currency' do
    c = Currency.init(@user, Currency::HEART)
    c.currency_logs.count.should == 1
  end

  it 'should be set action and value properly when Currency.init called' do
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'init', value: Currency::DEFAULT_COUNT).and_call_original
    c = Currency.init(@user, Currency::HEART)
    cl = CurrencyLog.where('currency_id = ?', c.id).last
    cl.currency.should eq c
    cl.action.should eq 'init'
    cl.value.should == 5
  end

  it 'should be set action and value properly when currency.use called' do
    heart = Currency.init(@user, Currency::HEART)
    CurrencyLog.should_receive(:create).with(currency: anything, action: 'use', value: -1).and_call_original
    heart.use(1)
    cl = heart.currency_logs.last
    cl.action.should eq 'use'
    cl.value.should == -1
  end
end