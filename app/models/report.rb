class Report < ActiveRecord::Base
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
