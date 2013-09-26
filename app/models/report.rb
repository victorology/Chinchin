class Report < ActiveRecord::Base
  def self.make_reports(started_at, ended_at)
    users = Report.total_user_per_day(started_at, ended_at)
    likes = Report.total_like_per_day(started_at, ended_at)
    uniq_likes = Report.total_like_per_day(started_at, ended_at)
    chinchins = Report.total_chinchin_per_day(started_at, ended_at)
    chinchin_counts = Report.count_chinchins_per_day(started_at, ended_at)
    total_uniq_likes = Report.count_total_uniq_like_per_day(started_at, ended_at)
    total_mutual_likes = Report.count_mutual_likes_per_day(started_at, ended_at)

    keys = users.keys

    results = {}
    keys.each do |key|
      u = users[key]
      l = likes[key]
      q = uniq_likes[key]
      c = chinchins[key]
      cc = chinchin_counts[key]
      tu = total_uniq_likes[key]
      ml = total_mutual_likes[key]
      results[key] = u.merge(l).merge(q).merge(c).merge(cc).merge(tu).merge(ml)
    end
    results
  end

  def self.make_report(started_at, ended_at, sqls)
    keys = started_at.to_date.upto(ended_at.to_date).map { |day| day.strftime("%Y-%m-%d 00:00:00") }.compact
    results = {}

    keys.each do |key|
      result = {}
      sqls.each do |sql|
        sql[:result].default = 0
        result[sql[:title]] = sql[:result][key]
      end
      results[key[0..9]] = result
    end 
    results
  end

  def self.store_report(started_at, ended_at, sqls)
    keys = started_at.to_date.upto(ended_at.to_date).map { |day| day.strftime("%Y-%m-%d 00:00:00") }.compact

    sqls.each do |sql|
      title = sql[:title]
      results = sql[:result]
      results.default = 0
      keys.each do |key|
        if Report.where("title = ? and created_at BETWEEN ? and ?", title, key.to_date.beginning_of_day, key.to_date.end_of_day).count == 0
          report = Report.new
          report.title = title
          report.value = results[key]
          report.created_at = key.to_date.beginning_of_day
          report.save
        end
      end
    end
  end

  def self.count_report(started_at, ended_at, titles)
    sqls = []
    titles.each do |title|
      result = Report.where("created_at >=? and created_at <= ? and title = ?", started_at, ended_at, title).select(['created_at', 'value'])
      sqls << {:title => title, :result => sql_to_hash(result)}
    end
    make_report(started_at, ended_at, sqls)
  end

  def self.store_report_data(started_at, ended_at)
    puts "total users"
    store_total_user_per_day(started_at, ended_at)
    puts "total chinchin"
    store_total_chinchin_per_day(started_at, ended_at)
    puts "total likes"
    store_total_like_per_day(started_at, ended_at)
    puts "chinchin count"
    store_chinchins_per_day(started_at, ended_at)
    puts "total uniq likes"
    store_total_uniq_like_per_day(started_at, ended_at)
    puts "mutual likes"
    store_mutual_likes_per_day(started_at, ended_at)
  end

  def self.total_user_per_day_sql(started_at, ended_at)
    sqls = [
      {:title => 'total_users', :result => User.where("created_at BETWEEN ? and ? and status = 1", started_at, ended_at).group("DATE_TRUNC('day', created_at)").count},
      {:title => 'male_users', :result => User.where("created_at >= ? and created_at <= ? and gender = ? and status = 1", started_at, ended_at, "male").group("DATE_TRUNC('day', created_at)").count},
      {:title => 'female_users', :result => User.where("created_at >= ? and created_at <= ? and gender = ? and status = 1", started_at, ended_at, "female").group("DATE_TRUNC('day', created_at)").count}
    ]
  end

  def self.total_like_per_day_sql(started_at, ended_at)
    sqls = [
      {:title => 'total_likes', :result => Like.where("created_at >= ? and created_at <= ?", started_at, ended_at).group("DATE_TRUNC('day', created_at)").count },
      {:title => 'likes_from_male', :result => Like.joins(:user)
        .where("likes.created_at >= ? and likes.created_at <= ? and users.gender = ?", started_at, ended_at, "male")
        .group("DATE_TRUNC('day', likes.created_at)").count},
      {:title => 'likes_from_female', :result => Like.joins(:user)
        .where("likes.created_at >= ? and likes.created_at <= ? and users.gender = ?", started_at, ended_at, "female")
        .group("DATE_TRUNC('day', likes.created_at)").count},
      {:title => 'uniq_male_liked', :result => Like.joins(:user)
        .where("likes.created_at >= ? and likes.created_at <= ? and users.gender = ?", started_at, ended_at, "male")
        .group("DATE_TRUNC('day', likes.created_at)").count("users.id", distinct: true)},
      {:title => 'uniq_female_liked', :result => Like.joins(:user)
        .where("likes.created_at >= ? and likes.created_at <= ? and users.gender = ?", started_at, ended_at, "female")
        .group("DATE_TRUNC('day', likes.created_at)").count("users.id", distinct: true)}
    ]
  end

  def self.total_chinchin_per_day_sql(started_at, ended_at)
    sqls = [
      {:title => 'total_chinchins', :result => User.where("created_at >= ? and created_at <= ? and status = 0", started_at, ended_at).group("DATE_TRUNC('day', created_at)").count},
      {:title => 'male_chinchins', :result => User.where("created_at >= ? and created_at <= ? and gender = ? and status = 0", started_at, ended_at, "male").group("DATE_TRUNC('day', created_at)").count},
      {:title => 'female_chinchins', :result => User.where("created_at >= ? and created_at <= ? and gender = ? and status = 0", started_at, ended_at, "female").group("DATE_TRUNC('day', created_at)").count}
    ]
  end

  def self.store_total_user_per_day(started_at, ended_at)
    sqls = total_user_per_day_sql(started_at, ended_at)
    store_report(started_at, ended_at, sqls)
  end 

  def self.total_user_per_day(started_at, ended_at)
    count_report(started_at, ended_at, ['total_users', 'male_users', 'female_users'])
  end 

  def self.store_total_like_per_day(started_at, ended_at)
    sqls = total_like_per_day_sql(started_at, ended_at)
    store_report(started_at, ended_at, sqls)
  end

  def self.total_like_per_day(started_at, ended_at)
    count_report(started_at, ended_at, ['total_likes', 'likes_from_male', 'likes_from_female', 'uniq_male_liked', 'uniq_female_liked'])
  end

  def self.store_total_chinchin_per_day(started_at, ended_at)
    sqls = total_chinchin_per_day_sql(started_at, ended_at)
    store_report(started_at, ended_at, sqls)
  end

  def self.total_chinchin_per_day(started_at, ended_at)
    count_report(started_at, ended_at, ['total_chinchins', 'male_chinchins', 'female_chinchins'])
  end

  def self.sql_to_hash(sql_results)
    {}.tap { |h| sql_results.each { |r| h[r.created_at.strftime("%Y-%m-%d 00:00:00")] = r.value.to_i} }
  end

  def self.count_chinchins_per_day(started_at, ended_at)
    none_reports = Report.where("created_at >=? and created_at <= ? and title = 'count_chinchins_none'", started_at, ended_at).select(['created_at', 'value'])
    one_reports = Report.where("created_at >=? and created_at <= ? and title = 'count_chinchins_one'", started_at, ended_at).select(['created_at', 'value'])
    two_reports = Report.where("created_at >=? and created_at <= ? and title = 'count_chinchins_two'", started_at, ended_at).select(['created_at', 'value'])
    three_reports = Report.where("created_at >=? and created_at <= ? and title = 'count_chinchins_three'", started_at, ended_at).select(['created_at', 'value'])
    sqls = [
      {:title => 'no_chinchins', :result => sql_to_hash(none_reports)},
      {:title => 'one_chinchin', :result => sql_to_hash(one_reports)},
      {:title => 'two_chinchins', :result => sql_to_hash(two_reports)},
      {:title => 'three_more_chinchins', :result => sql_to_hash(three_reports)}
    ]
    make_report(started_at, ended_at, sqls)
  end

  def self.count_total_uniq_like_per_day(started_at, ended_at)
    total_uniq_male_reports = Report.where("created_at >=? and created_at <= ? and title = 'total_uniq_male_liked'", started_at, ended_at).select(['created_at', 'value'])
    total_uniq_female_reports = Report.where("created_at >=? and created_at <= ? and title = 'total_uniq_female_liked'", started_at, ended_at).select(['created_at', 'value'])
    sqls = [
      {:title => 'total_uniq_male_liked', :result => sql_to_hash(total_uniq_male_reports)},
      {:title => 'total_uniq_female_liked', :result => sql_to_hash(total_uniq_female_reports)},
    ]
    make_report(started_at, ended_at, sqls)
  end

  def self.count_mutual_likes_per_day(started_at, ended_at)
    mutual_likes_reports = Report.where("created_at >=? and created_at <= ? and title = 'total_mutual_likes'", started_at, ended_at).select(['created_at', 'value'])
    sqls = [
        {:title => 'total_mutual_likes', :result => sql_to_hash(mutual_likes_reports)},
    ]
    make_report(started_at, ended_at, sqls)
  end

  def self.store_chinchins_per_day(started_at, ended_at)
    started_at = started_at.to_date
    ended_at = ended_at.to_date
    
    if ended_at > Date.today
      ended_at = Date.today
    end
    started_at.upto(ended_at) do |day|
      report_count = 0
      begin
        report_count = Report.where('title like ? and created_at BETWEEN ? and ?' , "count_chinchin%", day.beginning_of_day, day.end_of_day).count
      rescue
      end
      if report_count == 0
        store_chinchins_at_certain_day(day)
      else
        puts 'skip...'
      end
    end
  end

  def self.store_total_uniq_like_per_day(started_at, ended_at)
    started_at = started_at.to_date
    ended_at = ended_at.to_date
    
    if ended_at > Date.today
      ended_at = Date.today
    end
    started_at.upto(ended_at) do |day|
      report_count = 0
      begin
        report_count = Report.where('title like ? and created_at BETWEEN ? and ?' , "total_uniq_%", day.beginning_of_day, day.end_of_day).count
      rescue
      end
      if report_count == 0
        store_total_uniq_like_at_certain_day(day)
      else
        puts 'skip...'
      end
    end
  end

  def self.store_mutual_likes_per_day(started_at, ended_at)
    started_at = started_at.to_date
    ended_at = ended_at.to_date

    if ended_at > Date.today
      ended_at = Date.today
    end
    started_at.upto(ended_at) do |day|
      report_count = 0
      begin
        report_count = Report.where('title = ? and created_at BETWEEN ? and ?' , "total_mutual_likes", day.beginning_of_day, day.end_of_day).count
      rescue
      end
      if report_count == 0
        store_mutual_likes_at_certain_day(day)
      else
        puts 'skip...'
      end
    end
  end

  def self.store_chinchins_at_certain_day(day)
    count = {"none"=>0, "one"=>0, "two"=>0, "three"=>0}
    User.where("created_at <= ? and status = 1", day.end_of_day).each do |user|
      c = user.registered_friends.where('users.created_at <= ?', day.end_of_day).count

      case c
      when 0 then count["none"] += 1
      when 1 then count["one"] += 1
      when 2 then count["two"] += 1
      else count["three"] += 1
      end
    end
    
    count.keys.each do |key|
      report = Report.new
      report.title = "count_chinchins_"+key
      report.value = count[key]
      report.created_at = day.beginning_of_day
      report.save
    end
  end

  def self.store_total_uniq_like_at_certain_day(day)
    ['male', 'female'].each do |gender|
      count = Like.joins(:user)
                  .where('likes.created_at <= ? and users.gender = ?', day.end_of_day, gender)
                  .count('users.id', distinct:true)

      report = Report.new
      report.title = "total_uniq_"+gender+"_liked"
      report.value = count
      report.created_at = day.beginning_of_day
      report.save
    end
  end

  def self.store_mutual_likes_at_certain_day(day)
    mutual_likes = []
    likes = Like.joins(:user).where("likes.created_at <= ? and users.gender = 'female'", day)
    likes.each do |like|
      if Like.where('user_id = ? and chinchin_id = ? and created_at <= ?', like.chinchin.id, like.user.id, day).count > 0
        mutual_likes.push(like)
      end
    end

    report = Report.new
    report.title = "total_mutual_likes"
    report.value = mutual_likes.count
    report.created_at = day.beginning_of_day
    report.save
  end

  def self.generate
    total_user = User.where('status = 1').count
    total_male_user = 0
    total_female_user = 0
    total_notspecified_user = 0
    total_chinchin = User.where('status = 0').count
    total_male_chinchin = 0
    total_female_chinchin = 0
    total_notspecified_chinchin = 0
    total_friendship = Friendship.all.count
    total_liked = Like.all.count
    total_liked_from_male = 0
    total_liked_from_female = 0
    total_liked_from_notspecified = 0
    user_liked = 0
    total_friends_in_chinchin = 0
    no_friends_in_chinchin = 0

    User.all.each do |user|
      friends_in_chinchin = user.registered_friends.count
      total_friends_in_chinchin += friends_in_chinchin
      if friends_in_chinchin == 0
        no_friends_in_chinchin += 1
      end

      if user.gender == "male"
        total_male_user += 1
      elsif user.gender == "female"
        total_female_user += 1
      else
        total_notspecified_user +=1
      end
    end

    Like.all.each do |like|
      if not like.chinchin.user.nil?
        user_liked += 1
      end

      if like.user.gender == 'male'
        total_liked_from_male += 1
      elsif like.user.gender == 'female'
        total_liked_from_female += 1
      else
        total_liked_from_notspecified += 1
      end
    end

    Chinchin.all.each do |chinchin|
      if chinchin.gender == 'male'
        total_male_chinchin += 1
      elsif chinchin.gender == 'female'
        total_female_chinchin += 1
      else
        total_notspecified_chinchin += 1
      end
    end

    data = {
        "Total User" => total_user,
        "Total Male User" => total_male_user,
        "Total Female User" => total_female_user,
        "Total User Has NO Friends in Chinchin" => no_friends_in_chinchin,
        "Total User Has One or More Friends in Chinchin" => (total_user - no_friends_in_chinchin),
        "Total Chinchin" => total_chinchin,
        "Total Male Chinchin" => total_male_chinchin,
        "Total Female Chinchin" => total_female_chinchin,
        "Total Not specified Chinchin" => total_notspecified_chinchin,
        "Total Friendship" => total_friendship,
        "Total Liked" => total_liked,
        "Total Liked in Chinchin" => user_liked,
        "Total Liked from Female" => total_liked_from_female,
        "Total Liked from Male" => total_liked_from_male,
        "Total Friends in Chinchin" => total_friends_in_chinchin,
        "Average Friends per User" => (total_friendship / Float(total_user)),
        "Average Friends in Chinchin per User" => (total_friends_in_chinchin / Float(total_user)),
        "Average Chinchins per Male User" => (total_female_chinchin / Float(total_male_user)),
        "Average Chinchins per Female User" => (total_male_chinchin / Float(total_female_user)),
    }

    data.each do |key, value|
      report = Report.new
      report.title = key.to_s
      report.value = value.to_f
      report.save!
    end
  end
end
