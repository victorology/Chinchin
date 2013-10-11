module ApplicationHelper

  # Returns the full title on a per-page basis.       # Documentation comment
  def full_title(page_title)                          # Method definition
    base_title = "Chinchin"  													# Variable assignment
    if page_title.empty?                              # Boolean test
      base_title                                      # Implicit return
    else
      "#{base_title} | #{page_title}"                 # String interpolation
    end
  end

  def currency_count(user, currency_type)
    user.currency(currency_type).current_count
  end

  def currency_timeleft(user, currency_type)
    c = user.currency(currency_type)
    if c.last_used_log.nil?
      return 0
    end
    return ((30*60) - (TimeUtil.get - c.last_used_log.created_at)) * 1000
  end
end