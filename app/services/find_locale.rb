# encoding: utf-8
require 'active_support/all'

class FindLocale
  def self.call(option)
    user_locale = option.fetch(:user_locale)
    accept_language = option.fetch(:accept_language)
    raw_locale = user_locale.presence || accept_language.presence || :ko
    raw_locale[0..1] == "ko" ? :ko : :en
  end
end