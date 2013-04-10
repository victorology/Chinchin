FactoryGirl.define do
  factory :friendship do |f|
    f.association :user
    f.association :chinchin
  end
end