require "spec_helper"

describe TimeUtil do
  it "should be equal to Time.now" do
    TimeUtil.freeze(nil)
    TimeUtil.get.should be_within(0.9).of(Time.now)
  end

  it "should be froze" do
    now = Time.now
    TimeUtil.freeze(now)
    TimeUtil.get.should eq now
  end

  it "should be froze and can be passed" do
    now = Time.new(2013, 10, 2, 0, 0, 0)
    TimeUtil.freeze(now)
    TimeUtil.pass_by(60*30)
    TimeUtil.get.should eq Time.new(2013, 10, 2, 0, 30, 0)
  end
end