class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :clock_in
end