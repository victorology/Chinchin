# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_room do |mr|
    mr.user1 nil
    mr.user2 nil
    mr.created_at nil
    mr.updated_at nil
  end
end
