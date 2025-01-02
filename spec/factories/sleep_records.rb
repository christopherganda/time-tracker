FactoryBot.define do
  factory :sleep_record do
    association :user
    association :clock_in
    clocked_in_at { 2.days.ago }
    clocked_out_at { 1.day.ago }
  end
end