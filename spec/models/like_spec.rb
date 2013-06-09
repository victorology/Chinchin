require 'spec_helper'

describe User do
  it 'returns one like when user like chinchin' do
    Like.all.count.should == 0
    user = FactoryGirl.create(:user, gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, gender:'female')
    user.like(chinchin)
    Like.all.count.should == 1
  end
end