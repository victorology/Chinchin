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
end
