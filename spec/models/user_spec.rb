# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  provider            :string(255)
#  uid                 :string(255)
#  name                :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  birthday            :string(255)
#  location            :string(255)
#  hometown            :string(255)
#  employer            :string(255)
#  position            :string(255)
#  gender              :string(255)
#  relationship_status :string(255)
#  school              :string(255)
#  locale              :string(255)
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe User do
  it 'return false when a given chinchin has same gender' do
    user = FactoryGirl.create(:user, gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, gender:'male')
    user.pass_default_chinchin_filter(chinchin).should == false
  end
  it 'return false when a given chinchin is married' do
    user = FactoryGirl.create(:user, gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, gender:'female', relationship_status:'Married')
    user.pass_default_chinchin_filter(chinchin).should == false
  end
  it 'return false when a given chinchin is engaged' do
    user = FactoryGirl.create(:user, gender: 'male')
    chinchin = FactoryGirl.create(:chinchin, gender:'female', relationship_status:'Engaged')
    user.pass_default_chinchin_filter(chinchin).should == false
  end

  it 'can register' do
    VCR.use_cassette("fetched_facebook_friends") do
      user = FactoryGirl.create(:user, gender: 'male', oauth_token: "CAAFAjlSNc70BADjEJEn2nmOCeHq9EkOiCX4YMtZCcDIHYA8jZBv663japYreY0rYxNtJIPzkuwZAOb7C7V7GnB4f0IugaTHrdwbWnLhQY8ZAMC3eparTEQZAgydqGbkIL09jCPPH9LYYq7dYo5U3J")
      friends_uids = user.friends.map(&:identifier)
      user.add_friends_to_chinchin
      friends_in_chinchin = user.chinchins
      friends_in_chinchin.map(&:uid).should == friends_uids
    end
  end

  context 'Like' do
    it 'can like somebody' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = stub(:user_or_chinchin, id: "100", first_name: "my_name", users: [], user: nil)
      user.like(chinchin)
      user.liked(chinchin).should be_true
    end
  end

  context 'View' do
    it 'can view somebody' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = stub(:user_or_chinchin, id: "100", first_name: "my_name", users: [], user: nil)
      user.view(chinchin)
      user.viewed(chinchin).should be_true
    end
  end
end
