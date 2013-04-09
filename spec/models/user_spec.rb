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
end
