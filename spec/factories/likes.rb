FactoryGirl.define do
  factory :like do |l|
    l.association :user
    l.association :chinchin
  end
end