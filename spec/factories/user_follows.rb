FactoryBot.define do
  factory :user_follow do
    association :follower, factory: :user
    association :followee, factory: :user
  end
end