FactoryBot.define do
  factory :clock_in do
    association :user
    clocked_in_at { 2.days.ago }
    is_clocked_out { false }
  end
end