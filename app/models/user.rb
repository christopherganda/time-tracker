class User < ApplicationRecord
  # Get a user's followings' id
  def following_ids
    UserFollow.where(follower_id: id).pluck(:followee_id)
  end

  # Get a user's followers' id
  def follower_ids
    UserFollow.where(followee_id: id).pluck(:follower_id)
  end

  # Get a user's followings' information
  def followings
    User.where(id: following_ids).pluck(:name)
  end

  # Get a user's followers' information
  def followers
    User.where(id: follower_ids).pluck(:name)
  end

  def clock_ins
    ClockIn.where(user_id: id)
    .order(clocked_in_at: :desc)
    .limit(7)
    .pluck(:clocked_in_at, :is_clocked_out)
  end

  def clock_ins_json
    clock_ins.map do |clocked_in_at, is_clocked_out|
      {
        clocked_in_at: clocked_in_at.strftime("%Y-%m-%d %H:%M:%S"),
        is_clocked_out: is_clocked_out
      }
    end
  end

  def followings_sleep_records
    SleepRecord
    .where(user_id: following_ids)
    .where(clocked_in_at: 7.days.ago..Time.current)
    .select(
      'user_id AS followee_id, 
      (clocked_out_at - clocked_in_at) AS sleep_length, 
      clocked_in_at, 
      clocked_out_at'
    )
    .order('sleep_length DESC')
  end
end