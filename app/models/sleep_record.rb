class SleepRecord < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :clock_in, optional: true
end