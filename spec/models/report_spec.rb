require 'spec_helper'

describe Report do
  before(:each) do
    @started_at = '2013-09-01'
    @ended_at = '2013-09-01'

    user = User.new
    user.gender = 'male'
    user.created_at = '2013-09-01'.to_date.beginning_of_day
    user.status = 1
    user.save
    Report.delete_all
  end

  after(:each) do
    User.delete_all
  end

  it 'total_user_per_day_sql' do
    sqls = Report.total_user_per_day_sql(@started_at, @ended_at)
    sqls[0][:result].should == {'2013-09-01 00:00:00' => 1} # total_users
    sqls[1][:result].should == {'2013-09-01 00:00:00' => 1} # male_users
    sqls[2][:result].should == {} # female_users
  end

  it 'store_report' do
    sqls = Report.total_user_per_day_sql(@started_at, @ended_at)
    Report.store_report(@started_at, @ended_at, [sqls[0]])
    Report.all.count.should == 1
    Report.store_report(@started_at, @ended_at, [sqls[1]])
    Report.all.count.should == 2
    Report.store_report(@started_at, @ended_at, [sqls[2]])
    Report.all.count.should == 3
    Report.store_report(@started_at, @ended_at, [sqls[0]])
    Report.all.count.should == 3
  end

  it 'about user' do
    Report.store_total_user_per_day(@started_at, @ended_at)

    result = Report.total_user_per_day(@started_at, @ended_at)
    result.should == {"2013-09-01" => {"total_users" => 1, "male_users" => 1, "female_users" => 0}}
  end

  it 'about mutual likes' do
    Report.store_mutual_likes_at_certain_day('2013-09-01'.to_date.end_of_day)
    result = Report.count_mutual_likes_per_day(@started_at, @ended_at)
    result.should == {"2013-09-01" => {"total_mutual_likes" => 0}}

    user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1)
    user2 = FactoryGirl.create(:user, name: 'lee', gender: 'female', uid: '1234', status: 1)

    Like.count.should == 0

    l = Like.new
    l.user = user
    l.chinchin = user2
    l.created_at = "2013-06-01".to_date.beginning_of_day
    l.save

    l2 = Like.new
    l2.user = user2
    l2.chinchin = user
    l2.created_at = "2013-09-01".to_date.beginning_of_day
    l2.save

    Like.count.should == 2
    Report.store_mutual_likes_at_certain_day('2013-09-01'.to_date.end_of_day)
    result = Report.count_mutual_likes_per_day(@started_at, @ended_at)
    result.should == {"2013-09-01" => {"total_mutual_likes" => 1}}
  end
end
