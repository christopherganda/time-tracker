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
end