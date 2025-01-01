class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :clock_in

  before_create :update_clock_in_to_used

  private

  def update_clock_in_to_used
    return unless clock_in.present?

    clock_in.update!(is_clocked_out: true)
  end
end