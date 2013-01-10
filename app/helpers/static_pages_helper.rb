module StaticPagesHelper
  def age(birthday)
    begin
      birthday = Date.strptime(birthday, '%m/%d/%Y')
      now = Time.now.utc.to_date
      now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    rescue TypeError, ArgumentError
      nil
    end
  end
end
