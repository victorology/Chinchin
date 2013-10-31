require 'spec_helper'

describe User do
  before(:each) do
    Like.delete_all
  end

  it 'returns one like when user like chinchin' do
    Like.all.count.should eq 0
    user = FactoryGirl.create(:user, gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, gender:'female')
    user.like(chinchin)
    Like.all.count.should eq 1
  end
end