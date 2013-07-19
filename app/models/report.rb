class Report < ActiveRecord::Base
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

  def self.total_like_per_day(started_at, ended_at)
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
    make_report(started_at, ended_at, sqls)
  end

  def self.total_user_per_day(started_at, ended_at)
    sqls = [
      {:title => 'total_users', :result => User.where("created_at >= ? and created_at <= ?", started_at, ended_at).group("DATE_TRUNC('day', created_at)").count},
      {:title => 'male_users', :result => User.where("created_at >= ? and created_at <= ? and gender = ?", started_at, ended_at, "male").group("DATE_TRUNC('day', created_at)").count},
      {:title => 'female_users', :result => female = User.where("created_at >= ? and created_at <= ? and gender = ?", started_at, ended_at, "female").group("DATE_TRUNC('day', created_at)").count}
    ]
    make_report(started_at, ended_at, sqls)
  end

  def self.total_chinchin_per_day(started_at, ended_at)
    sqls = [
      {:title => 'total_chinchins', :result => Chinchin.where("created_at >= ? and created_at <= ?", started_at, ended_at).group("DATE_TRUNC('day', created_at)").count},
      {:title => 'male_chinchins', :result => Chinchin.where("created_at >= ? and created_at <= ? and gender = ?", started_at, ended_at, "male").group("DATE_TRUNC('day', created_at)").count},
      {:title => 'female_chinchins', :result => Chinchin.where("created_at >= ? and created_at <= ? and gender = ?", started_at, ended_at, "female").group("DATE_TRUNC('day', created_at)").count}
    ]
    make_report(started_at, ended_at, sqls)
  end

  def self.count_chinchins_per_day(started_at, ended_at)
    result = {}

    # started_at = Date.strptime(started_at, "%Y-%m-%d")
    # ended_at = Date.strptime(ended_at, "%Y-%m-%d")
    if ended_at > Date.today
      ended_at = Date.today
    end
    started_at.upto(ended_at) do |day|
      result[day.strftime("%Y-%m-%d")] = count_chinchins_at_certain_day(day)
    end

    result
  end

  def self.count_chinchins_at_certain_day(day)
    count = {"none"=>0, "one"=>0, "two"=>0, "three"=>0}
    User.where("created_at <= ?", day.end_of_day).each do |user|
      c = Chinchin.joins(:users).where("users.id = ?", user.id)
                                .where("chinchins.user_id is not null")
                                .where("users.created_at <= ?", day.end_of_day)
                                .count

      case c
      when 0 then count["none"] += 1
      when 1 then count["one"] += 1
      when 2 then count["two"] += 1
      else count["three"] += 1
      end
    end
    count
  end

  def self.generate
    total_user = User.all.count
    total_male_user = 0
    total_female_user = 0
    total_notspecified_user = 0
    total_chinchin = Chinchin.all.count
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
      friends_in_chinchin = user.friends_in_chinchin.count
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
